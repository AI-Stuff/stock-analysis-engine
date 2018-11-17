#!/bin/bash

ticker=SPY
backtest_start_date=$(date --date="1 day ago" +"%Y-%m-%d")

if [[ "${1}" != "" ]]; then
    ticker="${1}"
fi

# this should be an integer for the number of days back
# to set as the backtest start date
if [[ "${2}" != "" ]]; then
    backtest_start_date=$(date --date="${2} day ago" +"%Y-%m-%d")
fi

distribute_to_workers=""
if [[ "${3}" != "" ]]; then
    distribute_to_workers="-w"
fi

use_date=$(date +"%Y-%m-%d")
ds_id=$(uuidgen | sed -e 's/-//g')
ticker_dataset="${ticker}-${use_date}_${ds_id}.json"
extract_loc="s3://algoready/${ticker_dataset}"
history_loc="s3://algohistory/${ticker_dataset}"
report_loc="s3://algoreport/${ticker_dataset}"
backtest_loc="s3://algoready/${ticker_dataset}"  # same as the extract_loc
processed_loc="s3://algoprocessed/${ticker_dataset}"  # archive it when done
start_date=$(date --date="${num_days_back} day ago" +"%Y-%m-%d")

test_exists=$(which sa)
if [[ "${test_exists}" == "" ]]; then
    source /opt/venv/bin/activate
    test_exists=$(which sa)
    if [[ "${test_exists}" == "" ]]; then
        echo "Error: unable to find the stock analysis command line tool: sa"
        echo ""
        echo "Please confirm it is is installed from:"
        echo "https://github.com/AlgoTraders/stock-analysis-engine#getting-started"
        echo ""
        exit 1
    fi
fi

echo ""
echo "extracting backtest algorithm-ready dataset for: ${ticker} id: ${ticker_dataset} for date range: ${backtest_start_date} to ${use_date} with s3: ${extract_loc}"
echo "sa -t ${ticker} -e ${extract_loc} -s ${start_date} -n ${use_date}"
sa -t ${ticker} -e ${extract_loc} -s ${start_date} -n ${use_date}


echo ""
echo "running backtest algorithm-ready dataset for: ${ticker} id: ${ticker_dataset} for date range: ${backtest_start_date} to ${use_date} with s3: ${backtest_loc}"
echo "sa -t ${ticker} -p ${history_loc} -o ${report_loc} -b ${backtest_loc} -e ${processed_loc} -s ${start_date} -n ${use_date}"
sa -t ${ticker} -p ${history_loc} -o ${report_loc} -b ${backtest_loc} -e ${processed_loc} -s ${start_date} -n ${use_date}

test_exists=$(which aws)
if [[ "${test_exists}" != "" ]]; then
    echo ""
    echo "Getting ${ticker} Algorithm-Ready datasets in s3://algoready:"
    aws --endpoint-url http://localhost:9000 s3 ls s3://algoready | grep ${ticker}
    echo ""
    echo "Getting ${ticker} Algorithm-Ready datasets in s3://algoready:"
    aws --endpoint-url http://localhost:9000 s3 ls s3://algoready | grep ${ticker}
    echo ""
    echo "Getting ${ticker} Algorithm-Ready datasets (for backtests) in s3://algoready:"
    aws --endpoint-url http://localhost:9000 s3 ls s3://algoready | grep ${ticker}
fi


exit 0
