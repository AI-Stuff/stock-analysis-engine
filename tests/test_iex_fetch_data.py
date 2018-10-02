"""
Test file for:
IEX Fetch Data
"""

import mock
import analysis_engine.mocks.mock_iex as mock_iex
from analysis_engine.mocks.base_test import BaseTestCase
from analysis_engine.consts import ev
from analysis_engine.iex.fetch_data \
    import fetch_data
from analysis_engine.api_requests \
    import build_iex_fetch_minute_request
from analysis_engine.api_requests \
    import build_iex_fetch_daily_request
from analysis_engine.api_requests \
    import build_iex_fetch_tick_request
from analysis_engine.api_requests \
    import build_iex_fetch_stats_request
from analysis_engine.api_requests \
    import build_iex_fetch_peers_request
from analysis_engine.api_requests \
    import build_iex_fetch_news_request
from analysis_engine.api_requests \
    import build_iex_fetch_financials_request
from analysis_engine.api_requests \
    import build_iex_fetch_earnings_request
from analysis_engine.api_requests \
    import build_iex_fetch_dividends_request
from analysis_engine.api_requests \
    import build_iex_fetch_company_request


class TestIEXFetchData(BaseTestCase):
    """TestIEXFetchData"""

    @mock.patch(
        ('pyEX.stocks.chartDF'),
        new=mock_iex.chartDF)
    def test_fetch_daily(self):
        """test_fetch_daily"""
        test_name = 'test_fetch_daily'
        work = build_iex_fetch_daily_request(
            label=test_name)

        work['ticker'] = test_name
        work['timeframe'] = '{}_daily'.format(
            test_name)

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
        self.assertEqual(
            res['timeframe'][0],
            work['timeframe'])
    # end of test_fetch_daily

    @mock.patch(
        ('pyEX.stocks.chartDF'),
        new=mock_iex.chartDF)
    def test_fetch_minute(self):
        """test_fetch_minute"""
        test_name = 'test_fetch_minute'
        work = build_iex_fetch_minute_request(
            label=test_name)

        work['ticker'] = test_name
        work['timeframe'] = '{}_minute'.format(
            test_name)

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
        self.assertEqual(
            res['timeframe'][0],
            work['timeframe'])
    # end of test_fetch_minute

    @mock.patch(
        ('pyEX.stocks.chartDF'),
        new=mock_iex.chartDF)
    def test_fetch_tick(self):
        """test_fetch_tick"""
        work = build_iex_fetch_tick_request(
            label='test_fetch_tick')

        work['ticker'] = 'test_fetch_tick'
        work['timeframe'] = 'test_fetch_tick'

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
        self.assertEqual(
            res['timeframe'][0],
            work['timeframe'])
    # end of test_fetch_tick

    @mock.patch(
        ('pyEX.stocks.stockStatsDF'),
        new=mock_iex.stockStatsDF)
    def test_fetch_stats(self):
        """test_fetch_stats"""
        test_name = 'test_fetch_stats'
        work = build_iex_fetch_stats_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_stats

    @mock.patch(
        ('pyEX.stocks.peersDF'),
        new=mock_iex.peersDF)
    def test_fetch_peers(self):
        """test_fetch_peers"""
        test_name = 'test_fetch_peers'
        work = build_iex_fetch_peers_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_peers

    @mock.patch(
        ('pyEX.stocks.newsDF'),
        new=mock_iex.newsDF)
    def test_fetch_news(self):
        """test_fetch_news"""
        test_name = 'test_fetch_news'
        work = build_iex_fetch_news_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_news

    @mock.patch(
        ('pyEX.stocks.financialsDF'),
        new=mock_iex.financialsDF)
    def test_fetch_financials(self):
        """test_fetch_financials"""
        test_name = 'test_fetch_financials'
        work = build_iex_fetch_financials_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_financials

    @mock.patch(
        ('pyEX.stocks.earningsDF'),
        new=mock_iex.earningsDF)
    def test_fetch_earnings(self):
        """test_fetch_earnings"""
        test_name = 'test_fetch_earnings'
        work = build_iex_fetch_earnings_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_earnings

    @mock.patch(
        ('pyEX.stocks.dividendsDF'),
        new=mock_iex.dividendsDF)
    def test_fetch_dividends(self):
        """test_fetch_dividends"""
        test_name = 'test_fetch_dividends'
        work = build_iex_fetch_dividends_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_dividends

    @mock.patch(
        ('pyEX.stocks.companyDF'),
        new=mock_iex.companyDF)
    def test_fetch_company(self):
        """test_fetch_company"""
        test_name = 'test_fetch_company'
        work = build_iex_fetch_company_request(
            label=test_name)

        work['ticker'] = test_name

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
        self.assertEqual(
            res['symbol'][0],
            work['ticker'])
    # end of test_fetch_company

    """
    Integration Tests

    Please ensure redis and minio are running and run this:

    ::

        export INT_TESTS=1

    """

    def test_integration_fetch_daily(self):
        """test_integration_fetch_daily"""
        if ev('INT_TESTS', '0') == '0':
            return

        # store data
        work = build_iex_fetch_daily_request(
            label='test_integration_fetch_daily')

        res = fetch_data(
            work_dict=work)
        self.assertIsNotNone(
            res)
    # end of test_integration_fetch_daily

# end of TestIEXFetchData
