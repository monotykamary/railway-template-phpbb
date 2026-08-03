#!/usr/bin/env python3
import os,re,time,requests
b=os.environ['BASE_URL'].rstrip('/');pw=os.environ['ADMIN_PASSWORD'];home=requests.get(b+'/index.php',timeout=30);assert home.status_code==200 and 'phpBB' in home.text
def submit(password):
 s=requests.Session();g=s.get(b+'/ucp.php?mode=login',timeout=30);fields={k:re.search(fr'name="{k}" value="([^"]+)"',g.text).group(1) for k in ('form_token','creation_time','sid')};fields.update(username='admin',password=password,login='Login',redirect='index.php');action=re.search(r'<form action="([^"]+mode=login[^"]*)"',g.text).group(1).replace('&amp;','&');time.sleep(3);return s,s.post(requests.compat.urljoin(b+'/',action),data=fields,allow_redirects=False,timeout=30)
_,wrong=submit('wrong-password');assert wrong.status_code==200 and ('incorrect' in wrong.text.lower() or 'invalid' in wrong.text.lower())
s,login=submit(pw);assert login.status_code in (302,303) and login.headers.get('location')
if b.startswith('https://'):
 dashboard=s.get(requests.compat.urljoin(b+'/',login.headers['location']),timeout=30);assert dashboard.status_code==200 and 'logout' in dashboard.text.lower()
blocked=requests.get(b+'/install/app.php',timeout=30);assert blocked.status_code==404
print('phpBB smoke checks passed')
