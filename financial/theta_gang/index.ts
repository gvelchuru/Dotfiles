import * as fs from "fs";
import * as parse from "csv-parse/lib/sync";
const axios = require("axios").default;
import * as querystring from "querystring";
//import axiosRetry, { exponentialDelay } from "axios-retry";
const client_id = "E7M6UYRBBDLH15WDB1RK5IMAHZRRUBOK@AMER.OAUTHAP";
const api_key = "E7M6UYRBBDLH15WDB1RK5IMAHZRRUBOK";
const iex_url = "https://cloud.iexapis.com/stable/";
const iex_token = "pk_a4c32445d1ee48c88bee5c0548275088";

let rawstocks = fs.readFileSync("SUSL_holdings.csv", { encoding: "utf-8" });
rawstocks = rawstocks.substring(rawstocks.indexOf("Ticker"));
const stocktable = parse(rawstocks, { skip_lines_with_error: true });
//const stocks = stocktable.map((item: string[]) => {
//return item[0];
//});
const stocks = ["MSFT"];
const quotes = {};

async function last3Months(stock: string) {
  try {
    //const response = await axios.get(
    //"https://api.tdameritrade.com/v1/marketdata/" + stock + "/quotes"
    //);
    //TODO: SWITCH TO LIVE DATA
    //axiosRetry(axios, { retries: 5 });
    //axiosRetry(axios, { retryDelay: exponentialDelay });
    const response = await axios.get(
      "https://api.tdameritrade.com/v1/marketdata/" + stock + "/pricehistory",
      {
        params: {
          periodType: "month",
          period: "3",
          frequencyType: "daily",
          frequency: "1"
        }
      }
    );
    return response.data;
  } catch (e) {
    console.log(e);
  }
}

async function get_auth() {
  axios.defaults.headers.post["Content-Type"] =
    "application/x-www-form-urlencoded";
  try {
    const refresh_token = fs.readFileSync("refresh_token.txt", {
      encoding: "utf-8"
    });
    const response = await axios.post(
      "https://api.tdameritrade.com/v1/oauth2/token",
      querystring.stringify({
        grant_type: "refresh_token",
        refresh_token: refresh_token,
        client_id: client_id,
        access_type: "",
        code: "",
        redirect_uri: ""
      })
    );
    return response.data.access_token;
  } catch (e) {
    console.log(e);
  }
}

get_auth().then(auth_string => {
  console.log(auth_string);
  //axios.defaults.headers.common["Authorization"] = "Bearer " + auth_string;
  //Promise.all(
  //stocks.map(async (stock: string) => {
  //let latestQuote = await last3Months(stock);
  //latestQuote = latestQuote[latestQuote.length - 1];
  ////const quoteData = latestQuote[stock];
  ////if (quoteData) {
  ////quotes[stock] = quoteData["lastPrice"];
  ////}
  //})
  //).then(() => {
  //console.log(quotes);
  //console.log(Object.keys(quotes).length);
  //});
});
