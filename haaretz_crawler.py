#-*- coding: utf-8 ':'
#Author: Gerth Jaanimäe
#Skript Haaretz'ist "Apartheid" märksõna sisaldavate artiklite kokkukraapimiseks.

import requests
import codecs
from bs4 import BeautifulSoup
import time
import re
import os
import sys
#Rubriigid, milles olevaid artikleid vaadatakse.
categories=["israel-news", "opinion", "news", "jewish"]

#Funktsioon, kus kirjeldatakse http päringu päised ja mis annab vastuseks lehekülje html koodi.
#Ühtlasi kirjutab logifaili lingi, mida külastatakse.
def download(url):
	headers = {
		'User-Agent': 'Crawler to collect text corpora for scientific purposes.',
		'From': 'gerthj@ut.ee'
	}
	with codecs.open("haaretz.log", "a", encoding="utf-8") as fout:
		fout.write(url+"\n")
	time.sleep(10)
	response = requests.get(url, headers=headers)
	return response.text


#Funktsioon, mis töötleb artiklit. Kirjutab tulemuse tekstifailidesse.
def processArticle(url):
	page=download(url)
	soup=BeautifulSoup(page, "html.parser")
	try:
		#Võtame välja pealkirja
		title=soup.find("meta", attrs={'property':'og:title'})['content']
		date=soup.find("meta", attrs={'property': 'article:published', 'itemprop': 'datePublished'})['content']
	except:
		return 1
	#Võtame välja artikli sisu.
	entry=soup.find_all("p", attrs={'class':'t-body-text'})
	#Kuna artikkel tuli eraldi lõikude kaupa, paneme need kokku.
	content=""
	for p in entry:
		content+=p.text+"\n"
	#Failile nimeks urlis olev nimi.
	filename=url.split("/")[-1]
	#Vaatame, kas sõna "Israel" on sisus olemas. "Apartheid sai juba lehe otsinguga välja vaadatud."
	if "Israel" in content:
		#Vaatame, millisesse kategooria kausta artikkel panna.
		category=""
		for i in categories:
			if i in url:
				category=i
		#Vaatame, kas kaust eksisteerib.
		if not os.path.exists(os.path.join("texts-haaretz", category)):
			os.mkdir(os.path.join("texts-haaretz", category))
		#Kirjutame sisu faili.
		with codecs.open(os.path.join("texts-haaretz", category, filename+".txt"), "w", encoding="utf-8") as fout:
			fout.write("Title: "+title+"\n")
			fout.write("Date: "+date+"\n")
			fout.write(content)

#Ühe aasta postituste vaatamine.
def processPosts(url):
	page=download(url)
	soup=BeautifulSoup(page, "html.parser")
	#Võtame artiklite loendi.
	posts=soup.find_all("div", attrs={'class': 'post'})
	for post in posts:
		link=post.find("a")['href']
		#Vaatame, kas artikkel on määratud rubriigist.
		for category in categories:
			if category in link and "world-news" not in link and "breaking-news" not in link:
				processArticle(link)
	#Vaatame, kas õnnestub sama aasta postituste järgmisele lehele minna.
	#Kui jah, siis kutsume rekursiivselt funktsiooni uuesti välja. Kui ei, lõpetame töö.
	try:
		next=soup.find("a", attrs={'class': 'next'})['href']
		return processPosts(next)
	except:
		return 0

#Hakkame aastate kaupa vaatama.
for year in range(2000, 2017):
	pagenumber=0
	processPosts("http://www.haaretz.com/misc/search-results?author=&startDate=01%2F01%2F"+str(year)+"&sort_method=date&page="+str(pagenumber)+"&q=apartheid&submitBtn=textSearch&endDate=31%2F12%2F"+str(year)+"&view=results&search_type=site")