#!/usr/bin/env python3
from dataclasses import dataclass, field


@dataclass
class Account:
    name: str
    id: str
    roles: list[str]

    regions: list[str] = field(default_factory=lambda: ["eu-west-1", "eu-north-1"])


@dataclass
class Block:
    name: str
    sso_account_id: str
    sso_role_name: str

    duration_seconds: int = 43200
    output: str = "json"
    region: str = "eu-west-1"
    sso_region: str = "eu-west-1"
    sso_start_url: str = "https://company.awsapps.com/start"

    def __str__(self):
        h = f"profile " if self.name != "default" else self.name
        if self.name != "default":
            h += f"{self.name}-{self.region}"
        if "SupportRole" in self.sso_role_name:
            h += "-ro"
        return (
            f"[{h}]\n"
            f"sso_account_id = {self.sso_account_id}\n"
            f"sso_region = {self.sso_region}\n"
            f"sso_role_name = {self.sso_role_name}\n"
            f"sso_start_url = {self.sso_start_url}\n"
            f"duration_seconds = {self.duration_seconds}\n"
            f"output = {self.output}\n"
            f"region = {self.region}\n"
        )


def main() -> None:
    blocks = [Block("default", "123412341234", "admin")]
    accounts = [
        Account("dev", "123412341234", ["admin", "read"]),
        Account("prod", "432143214321", ["read"]),
    ]
    for account in accounts:
        for region in account.regions:
            for role in account.roles:
                blocks.append(Block(account.name, account.id, role, region=region))
    [print(b) for b in blocks]


if __name__ == "__main__":
    main()