# Introduction

This repository contains a series of web scrapers / wrappers that use Nokogiri to parse product information from a number of different styles of ecommerce websites. The scrapers then output the product information as CSV data.

## Background

* http://ruby.bastardsbook.com/chapters/html-parsing/

## Dependencies

* Ruby 2.0.0 or higher
* [nokogiri (gem)](http://nokogiri.org/)

## Technical Notes

These scrapers have been anonymized for privacy reasons. **They are not immediately usable on any web site without modification.** As-is they demonstrate various methods for parsing different site structures that you might encounter, but you must adapt the wrapper (the components of the scraper that identify and parse specific HTML elements) to suit the particular site you are analyzing, and update the wrapper if the site changes.

For more on the subject, [see this article](http://en.wikipedia.org/wiki/Wrapper_(data_mining)).

The CSV output is VERY rudimentary, and in the case of Scraper D sometimes results in duplication of data. I might improve this in future projects, but the scrapers are bare-bones functional as they stand.

## Contact

If you have questions or comments regarding this project, hit me up on here or shoot me an email:

Stephen Torrence
stephen.torrence@gmail.com