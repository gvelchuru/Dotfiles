import * as fs from "fs";
import * as parse from "csv-parse/lib/sync";
const axios = require("axios").default;

const iex_url = "https://cloud.iexapis.com/stable/";
const iex_token = "pk_a4c32445d1ee48c88bee5c0548275088";

let rawstocks = fs.readFileSync("SUSL_holdings.csv", { encoding: "utf-8" });
rawstocks = rawstocks.substring(rawstocks.indexOf("Ticker"));
const stocktable = parse(rawstocks, { skip_lines_with_error: true });
const stocks = stocktable.map((item: string[]) => {
  return item[0];
});
const quotes = {};

//TODO: BATCH
async function stockUpdate(stock: string) {
  try {
    const response = await axios.get(
      iex_url + "stock/" + stock + "/chart/3m/",
      {
        params: {
          token: iex_token
        }
      }
    );
    return response.data[response.data.length - 1].high;
  } catch (e) {
    console.log(e);
  }
}

Promise.all(
  stocks.map(async (stock: string) => {
    const latestQuote = await stockUpdate(stock);
    if (latestQuote) {
      quotes[stock] = latestQuote;
    }
  })
).then(() => {
  console.log(quotes);
  console.log(Object.keys(quotes).length);
});
