// Modified from: https://www.shadertoy.com/view/7dG3zy
#define PI 3.14159265

const vec3 BACKGROUND_COLOR_1 = vec3(0.03, 0.03, 0.04);
const vec3 BACKGROUND_COLOR_2 = vec3(0.0, 0.0, 0.01);

const vec3 RING_COLOR_1 = vec3(0.01, 0.01, 0.02);
const vec3 RING_COLOR_2 = vec3(0.05, 0.05, 0.07);

const float RING_MIN_SIZE = 0.39;
const float RING_MAX_SIZE = .512;
const float RING_MIN_EDGE_SIZE = 0.014;
const float ZOOM_SPEED = 1./50.;

const float LENS_HEIGHT_MULTIPLIER = 0.05;
const vec3 LENS_IOR = vec3(2.286543164, 2.420857286, 2.435478974);
const vec3 LENS_TINT = vec3(1.00, 0.98, 0.94);

const float RING_HALO_INTENSITY = .005;
const vec3 RING_HALO_COLOR = vec3(0.03, 0.03, 0.04);
const vec3 RING_HIGHLIGHT_COLOR = vec3(0.02, 0.02, 0.03);

float noise2(vec2 uv)
{
    float v = dot(uv, vec2(101.9364, 96.45418));
    return fract(sin(v)*100000.0);
}

float rand(float x)
{
    return fract(sin(x)*10000.0);
}

float valueNoise1(float x)
{
    float i = floor(x);
    float f = fract(x);

    float bl = rand(i + 0.);
    float br = rand(i + 1.);

    return mix(bl, br, f);
}

float valueNoise(vec2 x)
{
    vec2 i = floor(x);
    vec2 f = fract(x);

    float bl = noise2(i + vec2(0., 0.));
    float br = noise2(i + vec2(1., 0.));
    float tl = noise2(i + vec2(0., 1.));
    float tr = noise2(i + vec2(1., 1.));

    return mix(bl, br, f.x) +
            (tl - bl) * f.y * (1. - f.x) +
            (tr - br) * f.y * f.x;
}

#define FBM_OCTAVES 3
float fbm(vec2 x)
{
    float v = 0.;
    float a = 0.5;

    float am = 0.5;
    float fm = 2.0;

    for(int i = 0; i < FBM_OCTAVES; ++i)
    {
        v += a * valueNoise(x);
        x *= fm;
        a *= am;
    }

    return v;
}

float gradientNoise(vec2 uv)
{
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float bl = noise2(i + vec2(0, 0));
    float br = noise2(i + vec2(1, 0));
    float tl = noise2(i + vec2(0, 1));
    float tr = noise2(i + vec2(1, 1));

    return mix(bl, br, f.x) +
        (tl - bl) * (1. - f.x) * f.y +
        (tr - br) * f.x * f.y;
}

float voronoi(vec2 uv)
{
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float d = 64.;
    for(int y = -1; y <= 1; ++y)
    {
        for(int x = -1; x <= 1; ++x)
        {
            vec2 b = vec2(x, y);
            vec2 c = b+noise2(i+b)-f;
            d = min(d, dot(c, c));
        }
    }
    return sqrt(d);
}

float smoothVoronoi(vec2 uv, float smoothing)
{
    vec2 i = floor(uv);
    vec2 f = fract(uv);

    float d = 0.;
    for(int y = -1; y <= 1; ++y)
    {
        for(int x = -1; x <= 1; ++x)
        {
            vec2 b = vec2(x, y);
            vec2 c = b+noise2(i+b)-f;
            float l = length(c);
            d += exp(-smoothing * l);
        }
    }
    return -1./smoothing*log(d);
}

float powerRemap(float x, float head, float tail)
{
    return pow(1.0 - pow(x, head), tail);
}

float speckles(vec2 uv, float maxSize, float sizeVariation)
{
    float intensity = 16./maxSize + pow(smoothstep(1., 0.,  cos(sqrt(uv.x)*24.0) * sin(sqrt(uv.y)*15.0) * cos(uv.x*uv.y*64.0)), .9)*sizeVariation;
    return powerRemap(voronoi(uv*50.), 1.5, intensity);
}

vec3 grid(vec2 uv)
{
    uv = 80. * uv;
    return vec3(sin(uv.x), sin(uv.y), 0);
}

vec3 calcRefract(vec3 vIn, vec3 n, float iorA, float iorB, out float fresnel)
{
    float iorRel = iorA/iorB;

    vIn *= -1.;
    float cosI = dot(vIn, n);
    float sinI = sqrt(1. - cosI * cosI);
    float sinT = sinI * iorRel;
    float cosT = sqrt(1. - sinT * sinT);

    float rPar = 0.;
    {
        float a = iorB * cosI;
        float b = iorA * cosT;
        rPar = (a - b) / (a + b);
    }
    float rPer = 0.;
    {
        float a = iorA * cosI;
        float b = iorB * cosT;
        rPer = (a - b) / (a + b);
    }
    fresnel = 0.5 * (rPar * rPar + rPer * rPer);

    return iorRel * -vIn + (iorRel * cosI - cosT) * n;
}

float lensHeight(vec2 uv)
{
    float v = length(uv);
    float isNotCenter = (v/(v+0.05));
    float a = LENS_HEIGHT_MULTIPLIER * (1.0 + sin(v*59.0)) * isNotCenter;
    float b = LENS_HEIGHT_MULTIPLIER * (1.0 + sin(v*59.0*cos(0.075*iTime))) * isNotCenter;
    return mix(b, a, min(1., v/0.3));
}

#define RAYMARCH_ITER 80
#define RAYMARCH_STEP 0.005

vec3 lensSurface(vec2 uv, float scale, out vec3 dIn, out vec3 normal)
{
    const float lensZPos = 1.0;

    vec3 p = vec3(0.0,0.0, 0);
    vec3 d = normalize(vec3(uv.x, uv.y, 1.0) - p);
    p += d * .7;
    float tDepth = 0.;

    for(int i = 0; i < RAYMARCH_ITER; ++i)
    {
        p += d * RAYMARCH_STEP;
        tDepth = lensZPos - lensHeight(p.xy / scale);
        if(tDepth < p.z)
        {
            break;
        }
    }

    vec3 v1l = p + vec3(-.0001, 0, 0);
    v1l.z = lensZPos - lensHeight(v1l.xy / scale);
    vec3 v1r = p + vec3(.0001, 0, 0);
    v1r.z = lensZPos - lensHeight(v1r.xy / scale);
    vec3 v2t = p + vec3(0, -.0001, 0);
    v2t.z = lensZPos - lensHeight(v2t.xy / scale);
    vec3 v2b = p + vec3(0, .0001, 0);
    v2b.z = lensZPos - lensHeight(v2b.xy / scale);

    normal = normalize(cross(v1r - v1l, v2t - v2b));
    dIn = d;
    return p;
}

vec2 lens(vec3 p, vec3 dIn, vec3 n, float ior, out float fresnel)
{
    const float bgPlaneZPos = 1.0;

    vec3 refractDir = calcRefract(dIn, n, 1.0, ior, fresnel);
    vec3 reflectDir = reflect(dIn, n);

    for(int i = 0; i < RAYMARCH_ITER; ++i)
    {
        p += refractDir * RAYMARCH_STEP;
        if(bgPlaneZPos < p.z)
        {
            break;
        }
    }
    return p.xy;
}

vec3 background(vec2 uv)
{
    float mixVal = smoothVoronoi(uv*2., 16.);
    vec3 col = mix(BACKGROUND_COLOR_1, BACKGROUND_COLOR_2, mixVal);

    float stringy1 = pow(voronoi(uv*4.)*.6, 3.);
    float stringy2 = pow(voronoi((uv+vec2(3,3))*5.)*.75, 3.);
    float stringy = mix(stringy1, stringy2, 0.8 + .5*sin(iTime*0.1));
    col += BACKGROUND_COLOR_1 * stringy;

    const float scanFreq = 1.8;
    const float scanIntensity = 0.05;
    float scanVal = 0.5 * (1.0 + sin(uv.y*iResolution.y*scanFreq));
    scanVal = scanIntensity*(scanVal-1.0)+1.0;
    col *= scanVal;

    return col;
}

float remapEdgeWrap(float x)
{
    x *= 200.;
    return x+(valueNoise1(x*0.1)*PI*2.8);
}

vec3 ringEdge(vec2 uv, vec2 edgeSpaceUV, vec3 inCol, vec3 outCol, float aspect)
{
    float edgePLateral = edgeSpaceUV.x;
    float edgePTransverse = edgeSpaceUV.y;

    float wrap = max(0., sin(remapEdgeWrap(edgePLateral) + edgePTransverse*6.));
    wrap = wrap;

    float q = sin(edgePTransverse*PI*.8);
    q *= q * q * q * q;
    q = q * q * q * q;
    q = q * q;
    float r = max(0., dot(normalize(vec3(uv, 1.)), normalize(vec3(-10,-30,0.))))*.3*(0.5+wrap*.5);


    float colMixCoef = fbm(uv*aspect*200.);
    colMixCoef *= 1. - wrap*.33;
    float v = gradientNoise(uv*5.);
    colMixCoef *= 0.5 + 1.5 * v * v;

    vec3 c = mix(RING_COLOR_1, RING_COLOR_2, colMixCoef);
    c = mix(mix(inCol, outCol*.8, edgePTransverse), c, sin(edgePTransverse*PI));
    c = mix(c, RING_HIGHLIGHT_COLOR * 10., q*r);

    float speckFact = 1.0 + 0.5*sin(iTime*.5 * edgeSpaceUV.x);
    c += pow(speckles(uv*1.0, 10., 30.), 0.2) * max(-.2, sin(edgeSpaceUV.x*9.0)) * RING_COLOR_2 * sin(edgePTransverse*PI) * speckFact;
    c += pow(speckles(uv*1.5, .1, 100.), 0.2) * max(-.2, sin(edgeSpaceUV.x*8.0)) * RING_COLOR_2 * sin(edgePTransverse*PI) * speckFact;

    float k = max(0., dot(normalize(vec3(uv, 1.)), normalize(vec3(10,30,0.)))) * cos(edgePTransverse);
    k = pow(k, 1.2);
    c = mix(c, inCol, min(0.8, k));

    return c;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 uv = fragCoord/iResolution.xy;

    float aspect = iResolution.x/iResolution.y;
    vec2 ringUV = uv;
    ringUV.x *= aspect;
    vec2 ringCenteredUV = ringUV - vec2(0.5*aspect, 0.5);

    const float ringTimeFac = (PI*0.5) * ZOOM_SPEED;
    float ringSize = RING_MIN_SIZE + (RING_MAX_SIZE-RING_MIN_SIZE)*(1.0 - 0.5*(1.+cos(iTime*ringTimeFac)));
    float ringScaleFactor = ringSize / RING_MIN_SIZE;
    float ringEdgeSize = RING_MIN_EDGE_SIZE * ringScaleFactor;
    float centerDist = length(ringCenteredUV);

    vec3 bg = background(ringCenteredUV)*.4;

    vec3 col = vec3(0,0,0);

    if(centerDist < ringSize)
    {
        float fresnel;
        vec3 normal;
        vec3 dIn;
        vec3 p = lensSurface(ringCenteredUV, ringScaleFactor, dIn, normal);

        vec2 fgUvR = lens(p, dIn, normal, LENS_IOR.r, fresnel);
        vec2 fgUvG = lens(p, dIn, normal, LENS_IOR.g, fresnel);
        vec2 fgUvB = lens(p, dIn, normal, LENS_IOR.b, fresnel);
        vec3 fg = vec3(
            pow(voronoi((fgUvR+vec2(1,1))*180.), 8.)*voronoi((fgUvR+vec2(3,3))*10.),
            pow(voronoi((fgUvG+vec2(1,1))*180.), 8.)*voronoi((fgUvG+vec2(3,3))*10.),
            pow(voronoi((fgUvB+vec2(1,1))*180.), 8.)*voronoi((fgUvB+vec2(3,3))*10.)
        );
        fg *= LENS_TINT;
        fg *= (1. + sin(100.*voronoi(fgUvR*10.) + iTime))*.5;
        fg *= 1. - fresnel;
        fg += fresnel * bg * pow(centerDist / ringSize, 8.0);
        col = fg;
    }
    else if(centerDist < ringSize + ringEdgeSize)
    {
        float edgePLateral = atan(ringCenteredUV.y, ringCenteredUV.x);
        float edgePTransverse = (centerDist - ringSize) / ringEdgeSize;
        col = ringEdge(ringCenteredUV / ringScaleFactor, vec2(edgePLateral, edgePTransverse), BACKGROUND_COLOR_2, bg, aspect);
    }
    else
    {
        col = bg;
        col += ((ringSize + ringEdgeSize)/pow(centerDist, 5.0)) * RING_HALO_INTENSITY * RING_HALO_COLOR;
    }

    vec4 terminalColor = texture(iChannel0, uv);
    vec3 blendedColor = terminalColor.rgb + col;
    fragColor = vec4(blendedColor, terminalColor.a);
}
