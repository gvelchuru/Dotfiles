import json

import requests

refresh_token = "oUhrvymUYjoXsr9aY11DOeP1McRAdV5qpRzCDrb4vM5UP77DEs+MIBCU/bDUkjh+iEJN3Lx2A7efCAgVmCdex8hiJTZVYGjJIWKl2HGYB2kgnbsIie/vKSG0c85244AVPLk+HSH//5T7UkxbcJ08s3OPXgoKvoFpjeGYoXRTBaCXf3v2iY8V4qpozvTgPAz+aHc15XvJnYx+yfdWMxwwscEnvhNp2IUQpopHGvkO157bxJTyIUbgjXlR8u7WzSMcMhfXz0Xh8mvfYsA3TPH//w6G7KbBDnFIaKwFG8eTVrD0s/6WufCSCkeA+Q7K92HzBFFmZRpJY9tbRpl+xaE+twDwV0u8OMzy9yLp9A7rGurlt/p7iutLdhbg0xI12QwLkxHr+ESmHV+IdfAEuMDS2S5ld04zLjI7WhM2NH0eHqfzP2OFPEhS7G2lHPK100MQuG4LYrgoVi/JHHvlfJQJ18qt2zNl5lwB0J1juDCcZ6DZP0Jwdk0qwJo8Uq0G5kPSW8k0NBSoHdgsML6Z/zCTmS2M7+kPWyGlvjNib3iDYvOLtaEjKnzUJ2G4W8CklkwFhVDjsaX5JWRlc2sWUMhSGqKrPyXLF55pCJJHahMap7AbIf1xXFYjLndoi82QaAWwEw3tHJnqc73pWlbNFfGEg2B1sTbPKsIB0fTf1xve5Q2Ulq4c8wYznaRefT0kLXRIyTondgOVaRhsMo7e+ynsn2k9nBroQqzPROLUyOIP3T+CHwk1yYG8MEV7XhUBtYbSSqYFKF01mFRIB+pC7YXQ2T/d2H6VqcO3M32YIt2NZWa3s75JDqZYNJzl5Pd+jr934X6eJzoMJaNh/fAXXNtSg7ENZNL7/lDH8DQddiw6CdohziRpkYCWdP2xxNYAFvPAokfSBWg/B/s=212FD3x19z9sWBHDJACbC00B75E"
client_id = "OHJS1MS1CB75NCZVB63AFEKCNAGF7Y0A@AMER.OAUTHAP"


def get_auth_code():
    payload = {
        "grant_type": "refresh_token",
        "access_type": "offline",
        "refresh_token": refresh_token,
        "client_id": "OHJS1MS1CB75NCZVB63AFEKCNAGF7Y0A@AMER.OAUTHAP",
    }
    auth_obj = requests.post(
        "https://api.tdameritrade.com/v1/oauth2/token", data=payload
    )
    try:
        return (json.loads(auth_obj.text))["access_token"]
    except:
        print(auth_obj.text)


if __name__ == "__main__":
    access_token = get_auth_code()
    headers = {
        "Authorization": "Bearer " + access_token,
        "periodType": "month",
        "period": "3",
        "frequencyType": "daily",
        "frequency": "1",
    }
    pricehistory = json.loads(
        requests.get(
            "https://api.tdameritrade.com/v1/marketdata/AAPL/pricehistory",
            headers=headers,
        ).text
    )
    print(pricehistory)
