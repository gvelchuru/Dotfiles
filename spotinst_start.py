import argparse
import os
import requests

API_TOKEN = os.environ["SPOTINST_KEY"]
SPOTINST_URL = "https://api.spotinst.io/aws/ec2/managedInstance"
SPOTINST_HEADERS = {
    "Content-Type": "application/json",
    "Authorization": "Bearer " + API_TOKEN,
}
SPOTINST_ACCOUNT = "act-63ceca67"
SPOTINST_INST = "smi-bcc8c967"


def manage_instance(type, to_start):
    url_dict = {True: "resume", False: "pause"}
    if to_start:
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
            SPOTINST_INST, url_dict[to_start], SPOTINST_ACCOUNT
        ),
        headers=SPOTINST_HEADERS,
    )
    print(r.json())


def get_all():
    print(
        requests.get(
            SPOTINST_URL + "?accountId=" + SPOTINST_ACCOUNT, headers=SPOTINST_HEADERS
        ).json()
    )


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("type")
    start_or_stop = parser.add_mutually_exclusive_group(required=True)
    start_or_stop.add_argument("--start", action="store_true")
    start_or_stop.add_argument("--stop", action="store_true")
    args = parser.parse_args()
    manage_instance(args.type, args.start)
