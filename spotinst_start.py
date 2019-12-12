import argparse
import os
import requests
import sys

API_TOKEN = os.environ["SPOTINST_KEY"]
SPOTINST_URL = "https://api.spotinst.io/aws/ec2/managedInstance"
SPOTINST_HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + API_TOKEN,
}
SPOTINST_ACCOUNT = "act-63ceca67"
SPOTINST_INST = "smi-bcc8c967"


def manage_instance(type, action):
    if action in ["pause", "recycle"] and type:
        r = requests.put(
            SPOTINST_URL + "/{}/accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
            headers=SPOTINST_HEADERS,
            data={
                "managedInstance": {
                    "compute": {
                        "launchSpecification": {
                            "instanceTypes": {"preferredType": {type}, "types": [type]}
                        }
                    }
                }
            },
        )
    r = requests.put(
        SPOTINST_URL
        + "/{}/{}?accountId={}".format(
            SPOTINST_INST, action, SPOTINST_ACCOUNT
        ),
        headers=SPOTINST_HEADERS,
    )
    if int(r.code) != 200:
	    print(r.json())


def get_all():
    print(
        requests.get(
            SPOTINST_URL + "?accountId=" + SPOTINST_ACCOUNT, headers=SPOTINST_HEADERS
        ).json()
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--type")
    parser.add_argument(
        "--action", choices=["pause", "resume", "recycle"], required=True
    )
    args = parser.parse_args()
    manage_instance(args.type, args.action)
