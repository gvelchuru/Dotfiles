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

INSTANCE_DICT = {
    "cpu": {
        2: ["c5.large", "c5d.large", "c5n.large", "c4.large"],
        4: ["c5.xlarge", "c5d.xlarge", "c5n.xlarge", "c4.xlarge"],
        8: ["c5.2xlarge", "c5d.2xlarge", "c5n.2xlarge", "c4.2xlarge"],
        16: ["c5.4xlarge", "c5d.4xlarge", "c5n.4xlarge", "c4.4xlarge"],
        36: ["c5.9xlarge", "c5.9xlarge", "c5n.9xlarge", "c4.8xlarge"],
        48: ["c5.12xlarge", "c5d.12xlarge"],
        72: ["c5.18xlarge", "c5d.18xlarge", "c5n.18xlarge", "c5n.metal"],
        96: ["c5.24xlarge", "c5d.24xlarge", "c5.metal", "c5d.metal"],
    },
    "mem": {
        16: [
            "r5.large",
            "r5a.large",
            "r5ad.large",
            "r5n.large",
            "r5d.large",
            "r4.large",
        ],
        32: [
            "r5.xlarge",
            "r5a.xlarge",
            "r5ad.xlarge",
            "r5n.xlarge",
            "r5d.xlarge",
            "r4.xlarge",
        ],
        64: [
            "r5.2xlarge",
            "r5a.2xlarge",
            "r5ad.2xlarge",
            "r5n.2xlarge",
            "r5d.2xlarge",
            "r4.2xlarge",
        ],
        128: [
            "r5.4xlarge",
            "r5a.4xlarge",
            "r5ad.4xlarge",
            "r5n.4xlarge",
            "r5d.4xlarge",
            "r4.4xlarge",
        ],
        256: [
            "r5.8xlarge",
            "r5a.8xlarge",
            "r5ad.8xlarge",
            "r5n.8xlarge",
            "r5d.8xlarge",
            "r4.8xlarge",
        ],
        384: [
            "r5.12xlarge",
            "r5a.12xlarge",
            "r5ad.12xlarge",
            "r5n.12xlarge",
            "r5d.12xlarge",
        ],
        512: [
            "r5.16xlarge",
            "r5a.16xlarge",
            "r5ad.16xlarge",
            "r5n.16xlarge",
            "r5d.16xlarge",
            "r4.16xlarge",
        ],
    },
    "gen": {
        4: [
            "t3.xlarge",
            "t3a.xlarge",
            "t2.xlarge",
            "m6g.xlarge",
            "m5.xlarge",
            "m5a.xlarge",
            "m5n.xlarge",
            "m4.xlarge",
        ],
        16: ["m6g.4xlarge", "m5.4xlarge", "m5a.4xlarge", "m5n.4xlarge", "m4.4xlarge"],
        32: ["m6g.8xlarge", "m5.8xlarge", "m5a.8xlarge", "m5n.8xlarge", "m4.8xlarge"],
        64: [
            "m6g.16xlarge",
            "m5.16xlarge",
            "m5a.16xlarge",
            "m5n.16xlarge",
            "m4.16xlarge",
        ],
    },
    "gpu": {1: ["p3.2xlarge", "p2.xlarge", "g4dn.xlarge", "g3s.xlarge"]},
}


def manage_instance(types, action, SPOTINST_INST):
    if types:
        r = requests.put(
            SPOTINST_URL + "/{}?accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
            headers=SPOTINST_HEADERS,
            json={
                "managedInstance": {
                    "compute": {
                        "launchSpecification": {
                            "instanceTypes": {"preferredType": types[0], "types": types}
                        }
                    }
                }
            },
        )
        print(r.text)
    if action:
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


def persist_block_devices(SPOTINST_INST):
    r = requests.put(
        SPOTINST_URL + "/{}/accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
        headers=SPOTINST_HEADERS,
        data={"managedInstance": {"persistence": {"persistBlockDevices": True}}},
    )
    try:
        print(r.json())
    except:
        print(r.text)
    r = requests.put(
        SPOTINST_URL + "/{}?accountId={}".format(SPOTINST_INST, SPOTINST_ACCOUNT),
        headers=SPOTINST_HEADERS,
        json={"managedInstance": {"compute": {"elasticIp": None}}},
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
    type = parser.add_mutually_exclusive_group()
    type.add_argument("--cpu", action="store_true")
    type.add_argument("--gpu", action="store_true")
    type.add_argument("--memory", action="store_true")
    type.add_argument("--gen", action="store_true")
    action_or_list = parser.add_mutually_exclusive_group()
    action_or_list.add_argument("--action", choices=["pause", "resume", "recycle"])
    action_or_list.add_argument("--list", action="store_true")
    parser.add_argument("--num")
    args = parser.parse_args()
    inst_type = None
    num_mapping = {
        args.cpu: "cpu",
        args.gpu: "gpu",
        args.memory: "mem",
        args.gen: "gen",
    }
    if any(num_mapping.keys()):
        if not args.num:
            raise Exception("need num")
        for arg, instance_dict_key in num_mapping.items():
            if arg:
                inst_type = INSTANCE_DICT[instance_dict_key][int(args.num)]
                break
    if args.action or inst_type:
        get_all()
        SPOTINST_INST = input("inst: ")
        manage_instance(inst_type, args.action, SPOTINST_INST)
    if args.list:
        client = boto3.client("ec2")
        instances = client.describe_instances()
        instances = [
            reservation["Instances"] for reservation in instances["Reservations"]
        ]
        interfaces = [
            [
                (
                    instance_obj["InstanceType"],
                    instance_obj["NetworkInterfaces"][0]["Association"][
                        "PublicDnsName"
                    ],
                )
                for instance_obj in instance
                if instance_obj["NetworkInterfaces"]
            ]
            for instance in instances
        ]
        flat_interfaces = [item for sublist in interfaces for item in sublist]
        print(flat_interfaces)
