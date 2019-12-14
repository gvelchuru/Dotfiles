import argparse
import os
import sys

import requests

API_TOKEN = os.environ["SPOTINST_KEY"]
SPOTINST_URL = "https://api.spotinst.io/aws/ec2/managedInstance"
SPOTINST_HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + API_TOKEN,
}
SPOTINST_ACCOUNT = "act-63ceca67"
SPOTINST_INST = "smi-bcc8c967"


def manage_instance(type, action):
    if action in ["resume", "recycle"] and type:
        preferredTypes = [type]
        r = requests.put(
            SPOTINST_URL + "/{}/accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
            headers=SPOTINST_HEADERS,
            data={
                "managedInstance": {
                    "compute": {
                        "launchSpecification": {
                            "instanceTypes": {
                                "preferredType": {type},
                                "types": preferredTypes,
                            }
                        }
                    }
                }
            },
        )
    r = requests.put(
        SPOTINST_URL
        + "/{}/{}?accountId={}".format(SPOTINST_INST, action, SPOTINST_ACCOUNT),
        headers=SPOTINST_HEADERS,
    )
    if int(r.code) != 200:
        print(r.json())


def burst_instance():
    r = requests.put(
        SPOTINST_URL + "/{}/accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
        headers=SPOTINST_HEADERS,
        data={
            "managedInstance": {
                "compute": {
                    "launchSpecification": {
                        "creditSpecification": {"cpuCredits": "unlimited"}
                    }
                }
            }
        },
    )
    try:
        print(r.json())
    except:
        print(r.text)


def get_all():
    print(
        requests.get(
            SPOTINST_URL + "?accountId=" + SPOTINST_ACCOUNT, headers=SPOTINST_HEADERS
        ).json()
    )


if __name__ == "__main__":
    # burst_instance()
    parser = argparse.ArgumentParser()
    parser.add_argument("--type", optional=True)
    parser.add_argument(
        "--action", choices=["pause", "resume", "recycle"], required=True
    )
    args = parser.parse_args()
    manage_instance(args.type, args.action)
