# Created: 2022-03-05
# Author: Alex Zajichek
# Package: carecompare
# Description: Unit tests

### show_topics
test_that(
  desc = "The number of topics returned matches the number shown on https://data.cms.gov/provider-data/topics",
  code = 
    {
      expect_equal(length(pdc_topics()), 12)
    }
)