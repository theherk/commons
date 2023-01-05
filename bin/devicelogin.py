#!/usr/bin/env python3
import asyncio
import keyring
from pyppeteer import launch
import argparse
import getpass

SERVICE = "aada"


def create_user(username):
    try:
        print(f"Creating Keyring entry for {username}")
        password = getpass.getpass()
        keyring.set_password(SERVICE, username, password)
    except Exception as e:
        print(f"Failed to get create user: {e}")
        raise
    return password


def get_password(username):
    try:
        print("Getting password from keyring")
        password = keyring.get_password(SERVICE, username)
        assert password is not None
    except Exception as e:
        valid_reply = dict(y=True, n=False)
        print(f"Failed getting password from Keyring: {e}")
        res = input("Would you like to create a Keyring entry? [y/n]: ")
        if valid_reply.get(res, False):
            password = create_user(username)
        else:
            raise
    return password


def delete_password(username):
    try:
        keyring.delete_password(SERVICE, username)
    except Exception as e:
        print("Failed to delete password from Keyring: {}".format(repr(e)))


async def main(args):
    if args.delete_password:
        delete_password(args.username)
        return
    password = get_password(args.username)
    browser = await launch(
        headless=not args.non_headless,
        args=["--no-sandbox", "--disable-setuid-sandbox"],
    )
    print("devicelogin page")
    page = await browser.newPage()
    await page.goto("https://microsoft.com/devicelogin", waitUntil="networkidle0")
    await page.waitForSelector('input[name="otc"]:not(.moveOffScreen)')
    await page.focus('input[name="otc"]')
    await page.keyboard.type(args.token)
    await page.keyboard.press("Enter")
    await page.waitForSelector(
        'input[name="loginfmt"]:not(.moveOffScreen)', visible=True
    )
    await page.focus('input[name="loginfmt"]')
    print("username")
    await page.keyboard.type(args.username)
    await page.click("input[type=submit]")
    await page.waitForSelector('input[name="passwd"]:not(.moveOffScreen)', visible=True)
    await page.focus('input[name="passwd"]')
    print("passwd")
    await page.keyboard.type(password)
    await page.click("input[type=submit]")
    print("submitted")
    await page.waitForSelector('input[value="Continue"]', visible=True)
    await page.focus('input[value="Continue"]')
    await page.click("input[type=submit]")
    print("ok clicked")
    await page.waitForSelector("#message", visible=True)
    await browser.close()


if __name__ == "__main__":
    argparser = argparse.ArgumentParser()
    argparser.add_argument(
        "--delete-password",
        "-d",
        required=False,
        action="store_true",
        help="Deletes keyring associated with username",
    )
    argparser.add_argument(
        "--non-headless",
        "-n",
        required=False,
        default=False,
        action="store_true",
        help="Show browser window",
    )
    argparser.add_argument(
        "token", metavar="TOKEN", nargs="?", default=False, help="Token for login"
    )
    argparser.add_argument("username", metavar="USERNAME", help="Username to login")
    args = argparser.parse_args()

    if not args.delete_password and not args.token:
        argparser.print_usage()
    else:
        asyncio.get_event_loop().run_until_complete(main(args))
