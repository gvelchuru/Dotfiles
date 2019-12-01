import json

import requests

refresh_token = "pJQKEThm1nna1uM/lHGTC8qDYs45yoRVfkB61DazzPTwKU8x58osbtl+aZnEb25LJG+JJLmxvUrBh+rv1Smme+rJC9+5ja50tw9lAml12RLRZ5z7YBwzn9Xq8AlSxlQb5wRTUluUO+fc/GHTjLEgcnTdywsod1MaJavUgXUi/BWNa6ewGEVZRhgrx8rRHzJVzIK/WkLTL6lpXHesmdWjHyDXQ/gF0EpVIdfSwp5FfcVr0KQdUkrKk1f96A8g5sVTyKsm9EDz/Yk2dUWTnJCHIYCZY0KfAqJppATYI2cMWy2O2TaymVZRWqXK1q4YK7h9VgWsMpGMfsEEftwXMfeWowmaRqtKbKJWrfEm4cxFGfJ4gpyffcH72ySfkQVo/1RJv3/HaoA3G+7e8+tWlqVxTSK0amdC1D34TQW5lTYjfg5xwowNb9za0B62DqL100MQuG4LYrgoVi/JHHvlh5wjb6Deg2SBfUGKE5X+IzEi5vG3J3cgqlUqLbmOs50CDlM0gH3z4aEtyuegBDhFxv8Rqko17zM6HZVrGb+GrJIy1WvuENtfb/Xska9LhC2UlkB11CmJqMx+EnrzM9hPzAMy+G54HCs+pxRS93aVaMRNXJ6JXnBVjqaF0aifhyeYbrUtFmhn01kYz0spIFz46FORLH5Fvr7tAOhlBd6rPu2AFGMKMHP98btwf1VPG/7a3vOvauFoJ7eq+NyOPGc/BAqRGltEtpg07u9CEIflWvxKC+bXxdMSde41J7O4Ks7ZJlYxg6poUvQjlFKRaHM/vQf1qmsofRflBRrTYuNsH0OLMErbKxzciUpJdqWT0HkbkYDBV7Xnl8hORdRcMek3v++RbkRJeGLj7LPWyjbKwlvDiu0Ju3/lWDPFOwpTKwI2pWiqOLnDduVPagk=212FD3x19z9sWBHDJACbC00B75E"


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
