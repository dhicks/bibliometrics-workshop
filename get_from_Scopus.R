## --------------------
## R Setup
if (!require('RCurl')) {
    install.packages('RCurl')
    library('RCurl')
}
## If you don't want to install and load the whole tidyverse, 
## do at least install and load xml2
if (!require('tidyverse')) {
    install.packages('tidyverse')
    library('tidyverse')
}
library('xml2')


## --------------------
## Quick note on XML
# library(XML)
## The XML library is more powerful and flexible than xml2. 
## It was also created by DSI's Duncan Temple Lang.  
## However, it has issues interacting with the namespaces in the xml
## files that the API returns.  We couldn't work these issues out 
## before this workshop.  Hopefully we will do so in the future. 


## --------------------
## Elsevier API Setup
## API website:  https://dev.elsevier.com
## My API Key -> <create account/login> -> Create API Key

## **In a separate file**, assign your API key like
api_key = '12345'
## **In the working script**, load this file by calling
source('api_key.R')


## --------------------
## List of documents to retrieve
scopus_export = read.csv('PeerJ.csv', 
                         stringsAsFactors = FALSE)
eids_to_retrieve = scopus_export$EID
eids_to_retrieve = eids_to_retrieve[1:200]

## The first EID is 2-s2.0-85020029458


## --------------------
## Scraping:  Abstract retrieval API
## https://dev.elsevier.com/retrieval.html#/Abstract_Retrieval

scrape_eid = function(this_eid) {
    base_url = 'https://api.elsevier.com/content/abstract/eid/'
    query_url = paste0(base_url, 
                       this_eid, 
                       '?apiKey=', api_key)
    response = RCurl::getURL(query_url)
    return(response)
}

## The query URL for the first doc (w/o the API key) is 
## https://api.elsevier.com/content/abstract/eid/2-s2.0-85020029458


## --------------------
## Some options for looping

## 1. scrape_eids is already vectored; returns chr
# scraped_xml = scrape_eid(eids_to_retrieve)

## 2. lapply: returns list
# scraped_xml = lapply(eids_to_retrieve, scrape_eid)

## 3. foreach: returns list; 
##     can be extended with parallel backend and progress bar
##     https://stackoverflow.com/questions/5423760/how-do-you-create-a-progress-bar-when-using-the-foreach-function-in-r#26519566
# if (require(foreach)) {
#     foreach(this_eid = eids_to_retrieve) %do% 
#         scrape_eid(this_eid)
# }

## 4. plyr: returns list; 
##     can be extended with either parallel backend or progress bar, 
##     but currently not both
scraped_xml = plyr::llply(eids_to_retrieve, 
                          scrape_eid, 
                          .progress = 'text')

save(scraped_xml, file = 'scraped_xml.Rdata')


## --------------------
## Some useful stuff
## XPath cheat sheet:  http://xpath.alephzarro.com/content/cheatsheet.html
## DOI for the first doc:  10.7717/peerj.3365
## Direct link for the first doc:  https://peerj.com/articles/3365/


## --------------------
## Parsing
## We'll use the xml2 package to parse the scraped xml
results = lapply(scraped_xml, xml2::read_xml)

## Take a look at the namespaces
xml_ns(results[[1]])
## Default namespace is d1
## *Either* remove default namespace
results = lapply(results, xml_ns_strip)
## *or* prefix all unqualified nodes with d1:  
## '//authors/author' -> '//d1:authors/d1:author'

## Some examples with xml2
xml_find_first(results[[1]], '//dc:identifier')
xml_text(xml_find_first(results[[1]], '//dc:identifier'))
results[[1]] %>%
    xml_find_first('//dc:identifier') %>%
    xml_text()

xml_find_all(results[[1]], '//author')
xml_find_all(results[[1]], '//authors/author')
xml_attr(xml_find_all(results[[1]], '//authors/author'), 
         'auid')
results[[1]] %>%
    xml_find_all('//authors/author') %>%
    xml_find_first('./ce:surname') %>%
    xml_text()

## NB xml_find_all() de-duplicates results; 
##    xml_find_first() output is always the same size as the input

## To get bibliography items as Scopus IDs:  
results[[1]] %>%
    xml_find_all('//bibliography/reference') %>%
    xml_find_first('./ref-info//itemid[@idtype="SGR"]') %>%
    xml_text()

## Some fields you might care about, and their XPath
'
| Field           | XPath                         |
|-----------------|-------------------------------|
| DOI             | //prism:doi                   |
| PubMed ID       | //pubmed-id                   |
| Scopus ID       | //dc:identifier               |
| EID             | //eid                         |
| Title           | //dc:title                    |
| Journal title   | //prism:publicationName       |
| Journal ISSN    | //prism:issn                  |
| Pub. date       | //prism:coverDate             |
| Author list     | //authors                     |
| Abstract        | //abstract/ce:para            |
| Author keywords | //authkeywords/author-keyword |
| ASJC codes      | //subject-areas/subject-area  |
| Bibliography    | //bibliography                |
| Citation count  | //citedby-count               |
'
## ASJC codes: https://service.elsevier.com/app/answers/detail/a_id/12007/supporthub/scopus/~/what-are-scopus-subject-area-categories-and-asjc-codes%3F/


## Putting all this together in a parsing function
## For each paper, we want a data frame with one row per author-paper, with 
## - EID, DOI, Scopus ID
## - Title
## - Surname and ID for each author

parse_xml = function (this_result) {
    eid = xml_text(xml_find_first(this_result, '//eid'))
    doi = xml_text(xml_find_first(this_result, '//prism:doi'))
    scopus_id_node = xml_text(xml_find_first(this_result, 
                                             '//dc:identifier'))
    scopus_id = unlist(regmatches(scopus_id_node, 
                                  regexec('[0-9]+', 
                                          scopus_id_node)))
    ## Or
    # scopus_id = stringr::str_extract(scopus_id_node, '[0-9]+')
    title = xml_text(xml_find_first(this_result, '//dc:title'))
    
    authors = xml_find_all(this_result, '//authors/author')
    auids = xml_attr(authors, 'auid')
    surnames = xml_text(xml_find_first(authors, './ce:surname'))
    
    data.frame(eid, doi, scopus_id, title, 
               auid = auids, surname = surnames, 
               stringsAsFactors = FALSE)
}

## Apply across the list of results and combine into a single dataframe
# plyr::ldply(results, parse_xml)
parsed_results = do.call(rbind, lapply(results, parse_xml))

save(parsed_results, file = 'parsed_results.Rdata')
write.csv(parsed_results, file = 'parsed_results.csv')
