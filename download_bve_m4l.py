import requests

ids = [ 
    1346, 
    1169, 
    1271, 
    3251, 
    2025, 
    6834, 
    2176, 
    2711, 
    2733, 
    3678, 
    4102, 
    6892, 
    5903, 
    6290, 
    6833, 
    6836, 
    6821, 
    6825, 
    6812, 
    6819, 
    6823, 
    6830, 
    6887, 
    6891, 
    6894, 
    6918, 
    6923, 
    6925, 
    7038
]

import requests

for id in ids:
    response = requests.post('https://maxforlive.com/download.php', data = {'submit': 'Download+Device', 'id': id})
    data = response.content
    filename = response.headers["Content-Disposition"].split("filename=\"")[1][:-1]
    with open(f'C:/Users/Li/Documents/Ableton/M4L devices/benjaminvanesser/{filename}', 'wb') as s:
        s.write(data)