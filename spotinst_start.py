#!/usr/bin/python3
import argparse
import os
import sys
import boto3

import requests

API_TOKEN = os.environ["SPOTINST_KEY"]
SPOTINST_URL = "https://api.spotinst.io/aws/ec2/managedInstance"
SPOTINST_HEADERS = {"Authorization": "Bearer " + API_TOKEN}
SPOTINST_ACCOUNT = "act-63ceca67"


def manage_instance(type, action, SPOTINST_INST):
    if action in ["resume", "recycle"] and type:
        preferredTypes = [type]
        r = requests.put(
            SPOTINST_URL + "/{}?accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
            headers=SPOTINST_HEADERS,
            json={
                "managedInstance": {
                    "compute": {
                        "launchSpecification": {
                            "instanceTypes": {
                                "preferredType": type,
                                "types": preferredTypes,
                            }
                        }
                    }
                }
            },
        )
        print(r.text)
    r = requests.put(
        SPOTINST_URL
        + "/{}/{}?accountId={}".format(SPOTINST_INST, action, SPOTINST_ACCOUNT),
        headers=SPOTINST_HEADERS,
    )
    # if int(r.code) != 200:
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
    items = requests.get(
        SPOTINST_URL + "?accountId=" + SPOTINST_ACCOUNT, headers=SPOTINST_HEADERS
    ).json()["response"]["items"]

    print([(item["config"]["name"], item["id"]) for item in items])


if __name__ == "__main__":
    # burst_instance()
    parser = argparse.ArgumentParser()
    parser.add_argument("--type")
    action_or_list = parser.add_mutually_exclusive_group()
    action_or_list.add_argument("--action", choices=["pause", "resume", "recycle"])
    action_or_list.add_argument("--list", action="store_true")
    args = parser.parse_args()
    if args.action:
        get_all()
        SPOTINST_INST = input("inst: ")
        manage_instance(args.type, args.action, SPOTINST_INST)
    if args.list:
        client = boto3.client("ec2")
        instances = client.describe_instances()
	instances = [reservation["Instances"] for reservation in instances["Reservations"]]
	print([instance.keys() for instance in instances])
