---
slideOptions: 
  theme: white
---

# Getting & Working with Bibliometric Data #

Daniel J. Hicks
Postdoctoral Fellow
Data Science Initiative
djhicks@ucdavis.edu

---

## Funding Disclosure ##

- My postdoc is funded by Elsevier (owners of Scopus). 
- Elsevier played no role in my hiring process. 
- While I will occasionally meet with Elsevier staff during my postdoc, they have no control over my projects, what I publish, my remarks here today, etc. 

---

## Outline ##
1. What is Bibliometrics? 
2. Scopus: Web Interface
3. Hazards of Citation Statistics
4. Scopus: API

---

# What is Bibliometrics? #

----

**Bibliometrics** is a quantiative research field that studies the research process, typically using publication metadata. 

----

![Citation network from Hicks 2016](http://journals.plos.org/plosone/article/figure/image?size=large&id=10.1371/journal.pone.0168597.g005)

[Hicks, Daniel J. 2016. “Bibliometrics for Social Validation.” PLOS ONE 11 (12):e0168597. doi:10.1371/journal.pone.0168597.](http://journals.plos.org/plosone/article?id=10.1371/journal.pone.0168597)

----

Bibliometrics can be compared to
- research program evaluation and portfolio analysis
- history, philosophy, and social studies of science
- digital humanities
- systematic review and meta-analysis
- [meta-research](http://metrics.stanford.edu/)
- [science of science policy](https://www.nsf.gov/funding/pgm_summ.jsp?pims_id=501084)

----

## Sources of Bibliometrics Data ##

- [Scopus](https://www.scopus.com/search/form.uri?display=affiliationLookup) and [Web of Science](http://apps.webofknowledge.com/WOS_GeneralSearch_input.do?product=WOS&search_mode=GeneralSearch&SID=4AyGui1aI63HMjfAXi7&preferencesSaved=)
    - [2016 analysis](https://link.springer.com/article/10.1007/s11192-015-1765-5)
    - Similar coverage for natural science and engineering
    - Scopus has better coverage for biomedical research and social science
    - Both have poor coverage for humanities
    - Less reliable for non-journal, non-English, published outside North America and EU

----

## Sources of Bibliometrics Data ##

- [Crossref](https://www.crossref.org/services/metadata-delivery/)
    - DOI metadata
    - Unrestricted public use
    - [R client for API](https://github.com/ropensci/rcrossref)
- [PubMed](https://www.ncbi.nlm.nih.gov/home/develop/api/)
    - Unrestricted public use
    - Good coverage only for biomedical research
- Google Scholar
    - Includes books and grey literature, so "better" for humanities and social science
    - Strict rules against / detection of automated scraping
    - [Metadata are highly unreliable](https://scholar.google.com/scholar?hl=en&as_sdt=0%2C5&q=%22the+structure+of+scientific+revolutions%22&btnG=)

---


# Scopus: Web Interface #

----

- [scopus.com](https://www.scopus.com)
    - [Scopus inclusion criteria](https://www.elsevier.com/solutions/scopus/content/content-policy-and-selection)
- Author Search
    - [Beware false duplicates!](https://www.scopus.com/results/authorNamesList.uri?origin=searchauthorlookup&src=al&edit=&poppUp=&basicTab=&affiliationTab=&advancedTab=&st1=Gershwin&st2=Eric&institute=&orcidId=&authSubject=LFSC&_authSubject=on&authSubject=HLSC&_authSubject=on&authSubject=PHSC&_authSubject=on&authSubject=SOSC&_authSubject=on&s=AUTHLASTNAME%28Gershwin%29+AND+AUTHFIRST%28Eric%29&sdt=&sot=&searchId=&exactSearch=off&sid=)

- Affiliation Search

----

## Advanced Search Fields ##

#### Word-name-date ####
    AUTH
    SRCTITLE
    PUBYEAR
    TITLE-ABS-KEY

#### Funder ####
    FUND-ALL

#### Identifier ####
    AF-ID
    AU-ID
    ORCID
    PMID
    DOI
    
----

- Forward Citation Search
- Analyze Search Results
- Exporting Search Results

---

# Hazards of Citation Statistics #

----

## Common Citation Statistics ## 

- Citation counts
- [Journal Impact Factor](https://clarivate.com/essays/impact-factor/), [CiteScore](https://www.scopus.com/sources.uri?zone=TopNavBar&origin=SearchAffiliationLookup)
- [h-index](http://www.benchfly.com/blog/h-index-what-it-is-and-how-to-find-yours/)

----

## Distrust in Numbers ##

- Database-dependent
    - ["Analysis of the genome sequence of the flowering plant Arabidopsis thaliana", Nature 408, 796-815 (14 December 2000)](https://www.nature.com/nature/journal/v408/n6814/full/408796a0.html)
        - [WOS](http://apps.webofknowledge.com/full_record.do?product=WOS&search_mode=GeneralSearch&qid=9&SID=4AyGui1aI63HMjfAXi7&page=1&doc=1): 4533 citations
        - [Scopus](https://www.scopus.com/record/display.uri?eid=2-s2.0-0034649566&origin=resultslist&sort=cp-f&src=s&st1=Eisen&st2=Jonathan&nlo=1&nlr=20&nls=count-f&sid=028a2a8ef5a8803b67d3e1ece74361c7&sot=anl&sdt=aut&sl=39&s=AU-ID%28%22Eisen%2c+Jonathan+A.%22+35247902700%29&relpos=0&citeCnt=5569&searchTerm=): 5569 citations
        - [Google Scholar](https://scholar.google.com/scholar?q=Analysis+of+the+genome+sequence+of+the+flowering+plant+Arabidopsis+thaliana): 8065 citations
- Disciplines have different citation patterns

----

## Distrust in Numbers ##

- [Gender bias](http://www.nature.com/news/bibliometrics-global-gender-disparities-in-science-1.14321)
- [Disciplinary bias](https://www.sciencedirect.com/science/article/pii/S0048733317301038)
- [Widespread delayed recognition](http://www.pnas.org/content/112/24/7426.full.pdf)
- Citations are counts
    - Discrete, left-bounded, have [long and thick right tails](https://quantixed.wordpress.com/2016/01/05/the-great-curve-ii-citation-distributions-and-reverse-engineering-the-jif/)
    - Models designed for Gaussian ("normal") distributions can break badly


----

## What Do Citations Do? ##

- ~~Recognize objective quality or merit~~
- Allocate credit
- Appeal to authority
- Demonstrate expertise
- Satisfy reviewers

----

## [Leiden Manifesto](https://www.nature.com/polopoly_fs/1.17351!/menu/main/topColumns/topLeftColumn/pdf/520429a.pdf?origin=ppub) ##

- Quantitative evaluation should support qualitative, expert assessment.
- **Measure performance against the research missions of the institution, group or researcher.**
- Keep data collection and analytical processes open, transparent and simple. 
- Avoid misplaced concreteness and false precision. 


---

# Scopus: API #

----

## Tour of the Elsevier API Site ##

### https://dev.elsevier.com ###

- API Key
    - [Weekly limits](https://dev.elsevier.com/api_key_settings.html)
- Interactive APIs
- API Specification
- Scopus vs. ScienceDirect

----

## Switch to the R file ##