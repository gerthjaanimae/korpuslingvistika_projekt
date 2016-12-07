#-*- coding: utf-8 ':'
#Author: Gerth Jaanimäe
#Skript jpost.com leheküljelt "apartheid" märksõnaga artiklite kokkukraapimiseks.

import requests
import codecs
from bs4 import BeautifulSoup
import time
import re
import os
import sys

#Funktsioon, kus kirjeldatakse http päringu päised ja mis annab vastuseks lehekülje html koodi.
#Ühtlasi kirjutab logifaili lingi, mida külastatakse.
def download(url):
	headers = {
		'User-Agent': 'Crawler to collect text corpora for scientific purposes.',
		'From': 'gerthj@ut.ee'
	}
	with codecs.open("jpost.log", "a", encoding="utf-8") as fout:
		fout.write(url+"\n")
	time.sleep(5)
	response = requests.get(url, headers=headers)
	return response.text
#Funktsioon artikli töötlemiseks.
#Kirjutab puhastatud artikli tekstifaili.
def processArticle(url):
	#Kategooriad, mille artikleid vaadatakse.
	categories=["Israel", "Israel-News", "Blog", "Opinion", "National-News"]
	#Kuna rubriigi saab kätte artikli lingist, siis vaatame sealt.
	category = url.split("/")[3]
	#Teeme kindlaks, mis kategooriaga tegemist. Kui artikkel pole meie nimekirjas olevast rubriigist, lõpetab funktsioon töö ning asutakse järgmise artikli kallale.
	
	for i in categories:
		if i in category:
			category=i
	if category not in categories:
		return 1
	page=download(url)
	#Kasutame html-i parsimiseks.
	page=BeautifulSoup(page, "html.parser")
	article=page.find("div", attrs={'class': 'article-text'})
	#Kui artiklist, ei õnnestunud midagi saada, lõpetame töö.
	if article==None:
		return 1
	#Puhastame artikli sodist, nagu reklaambännerid jms.
	for tag in article.find_all('div', attrs={'class': 'article-box-banner-wrap'}):
		tag.replaceWith('')
	for tag in article.find_all('div', attrs={'class': 'ClickFacebookLike'}):
		tag.replaceWith('')
	for tag in article.find_all('div', attrs={'class': 'msgtext'}):
		tag.replaceWith('')
	for tag in article.find_all('div', attrs={'class': 'middle-script'}):
		tag.replaceWith('')
	for tag in article.find_all('script'):
		tag.replaceWith('')
	
	for tag in article.find_all('div', attrs={'span class': 'topicBoxSpan ignoreOnModeling'}):
		tag.replaceWith('')
	#VÕtame ainult teksti välja ja eemaldame html märgendid.	
	article=article.getText()
	#Kuna mingit osa sodist ei õnnestunud viisakalt eemaldada, siis teeme seda jõuga.
	article=re.sub('More about.*', '', article)
	article=article.replace("|", "")
	article=article.strip()
	#Võtame välja pealkirja.
	try:
		title=page.find('h1').text
	except:
		title=url.split("/")[-1]
	title=title.strip()
	#Paneme failile nime
	filename=url.split("/")[-1]+".txt"
	#Vaatame, kas kategooriale vastav kaust on olemas. Kui ei ole, siis loome.
	if not os.path.exists(os.path.join("texts-jpost", category)):
		os.mkdir(os.path.join("texts-jpost", category))
	#Vaatame, kas artikkel vastab seatud tingimustele.
	if (category=="Israel" or category=="Israel-News" or category=="National-News") and "apartheid" in article:
		with codecs.open(os.path.join("texts-jpost", category, filename), "w", encoding="utf-8") as fout:
			fout.write("Title: "+title+"\n")
			fout.write("Date: "+date+"\n")
			fout.write(article)
	elif "Israel" in article and "apartheid" in article:
		with codecs.open(os.path.join("texts-jpost", category, filename), "w", encoding="utf-8") as fout:
			fout.write("Title: "+title+"\n")
			fout.write("Date: "+date+"\n")
			fout.write(article)

#Vaatame, kas skripti käivitamisel on antud aasta ja kuu.
#Kui ei ole, siis alustame 2005. aasta algusest.
if len(sys.argv)<2:
	startyear=2005
else:
	try:
		startyear=int(sys.argv[1])
	except:
		print ("Aastaarvuks tuleb sisestada täisarv.")
		sys.exit(1)
if len(sys.argv)<3:
	startmonth=1
else:
	try:
		startmonth=int(sys.argv[2])
	except:
		print ("Alustamiskuu tuleb sisestada täisarvuna vahemikus 1-12.")
		sys.exit(1)

#Hakkame arhiivi läbi vaatama.
for year in range(startyear, 2017):
	#Järgnevad read on selleks, et kindlustada see, et järgmine aasta tsükkel hakkaks pihta esimese kuuga, 
	#aga mitte sellega, mis sisendisse anti.
	if startmonth!=1:
		startloop=startmonth
		startmonth=1
	else:
		startloop=1
	#Hakkame läbi kammima.
	for month in range(startloop, 13):
		for day in range(1,32):
			date=str(day)+"/"+str(month)+"/"+str(year)
			
			url="http://www.jpost.com/ArticleArchive/ListArticleArchive.aspx?date="+date
			page=download(url)
			page=BeautifulSoup(page, "html.parser")
			#Võtame artiklite loendi.
			page=page.find('ul', attrs={'class':'news-feed-items-wrap'})
			if page==None:
				continue
			articles=page.find_all('li')
			for i in articles:
				link=i.find("a", href=True)
				link=link['href']
				processArticle(link)
			
