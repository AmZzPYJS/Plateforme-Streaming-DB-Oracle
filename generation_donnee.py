import csv
import random
from datetime import date, timedelta
random.seed(42)
N_USERS = 150
N_FILMS = 200
N_SERIES = 60
N_EPISODES = 300
N_VISIONNAGES = 1000
N_TELECH = 300
ABO_START = date(2025, 12, 1)
ABO_END   = date(2025, 12, 31)
START_2017 = date(2017, 1, 1)
END_2017   = date(2017, 12, 31)
PCT_2017   = 0.20  # 20% des visionnages
NULL = ""
def fmt(d):
    return d.strftime("%Y-%m-%d")
def rand_date(d1, d2):
    return d1 + timedelta(days=random.randint(0, (d2 - d1).days))
def age_on(birth, d):
    a = d.year - birth.year
    if (d.month, d.day) < (birth.month, birth.day):
        a -= 1
    return a
user_birth = {}
user_plan = {}
# Repartition 70% premium / 30% basique 
for u in range(1, N_USERS + 1):
    age = random.randint(13, 70)
    user_birth[u] = date(2025 - age, random.randint(1, 12), random.randint(1, 28))
    user_plan[u] = 2 if random.random() < 0.70 else 1
with open("prends.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["id_utilisateur", "id_abonnement", "debut_abonnement"])
    for u in range(1, N_USERS + 1):
        w.writerow([u, user_plan[u], fmt(ABO_START)])
limites = [0, 7, 12, 16, 18]
pays = ["France", "USA", "UK", "Japon", "Canada"]
film_limit = {}
with open("film.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["id_film", "titre", "annee_apparition", "pays_production", "duree", "limite_age"])
    for i in range(1, N_FILMS + 1):
        la = random.choice(limites)
        film_limit[i] = la
        annee = random.choice([2016, 2017, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025])
        w.writerow([i, f"Film_{i}", annee, random.choice(pays), random.randint(70, 180), la])
serie_limit = {}
with open("serie.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["id_serie", "titre", "annee_apparition", "pays_production", "limite_age"])
    for i in range(1, N_SERIES + 1):
        la = random.choice(limites)
        serie_limit[i] = la
        annee = random.choice([2016, 2017, 2017, 2018, 2019, 2020, 2021, 2022, 2023, 2024, 2025])
        w.writerow([i, f"Serie_{i}", annee, random.choice(pays), la])
pairs = set()
episodes = []  # (id_episode, id_serie)
eid = 1
f = open("episode.csv", "w", newline="", encoding="utf-8")
w = csv.writer(f)
w.writerow(["id_episode", "numero_episode", "numero_saison", "id_serie", "duree"])
while len(pairs) < N_EPISODES:
    sid = random.randint(1, N_SERIES)
    saison = random.randint(1, 5)
    ep = random.randint(1, 20)
    key = (sid, saison, ep)
    if key in pairs:
        continue
    pairs.add(key)
    duree = random.randint(20, 65)  # durée épisode réaliste
    w.writerow([eid, ep, saison, sid, duree])
    episodes.append((eid, sid))
    eid += 1
basique_count_dec2025 = {u: 0 for u in range(1, N_USERS + 1)}
star_films = [1, 2, 3, 4, 5]
star_series = [1, 2, 3, 4, 5]
with open("visionne.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["id_visionnage", "date_visionnage", "duree_visionnage", "likes", "id_utilisateur", "id_film", "id_episode"])
    vid = 1
    target_2017 = int(N_VISIONNAGES * PCT_2017)
    while vid <= N_VISIONNAGES:
        u = random.randint(1, N_USERS)
        if vid <= target_2017:
            d = rand_date(START_2017, END_2017)
        else:
            d = rand_date(ABO_START, ABO_END)
        if user_plan[u] == 1 and d.year == 2025 and d.month == 12 and basique_count_dec2025[u] >= 50:
            continue
        if random.random() < 0.5:
            fid = random.choice(star_films) if random.random() < 0.30 else random.randint(1, N_FILMS)
            limite = film_limit[fid]
            eid_val = NULL
            fid_val = fid
        else:
            # episode : 30% du temps un épisode venant d'une star_serie
            if random.random() < 0.30:
                # choisir un épisode d'une star serie
                star_sid = random.choice(star_series)
                eps_star = [e for e in episodes if e[1] == star_sid]
                if eps_star:
                    eid_tmp, sid = random.choice(eps_star)
                else:
                    eid_tmp, sid = random.choice(episodes)
            else:
                eid_tmp, sid = random.choice(episodes)
            limite = serie_limit[sid]
            fid_val = NULL
            eid_val = eid_tmp
        if age_on(user_birth[u], d) < limite:
            continue
        likes_base = 0.30  # 30% de like
        if (fid_val in star_films) or (fid_val == NULL and sid in star_series):
            likes_base = 0.45
        likes = 1 if random.random() < likes_base else 0
        w.writerow([vid, fmt(d), random.randint(10, 180), likes, u, fid_val, eid_val])
        if user_plan[u] == 1 and d.year == 2025 and d.month == 12:
            basique_count_dec2025[u] += 1
        vid += 1
forced_film = 1
forced_count = 130  # garantit >100
with open("telecharge.csv", "w", newline="", encoding="utf-8") as f:
    w = csv.writer(f)
    w.writerow(["id_telechargement", "date_telechargement", "id_utilisateur", "id_film", "id_episode"])
    tid = 1
    while forced_count > 0:
        u = random.randint(1, N_USERS)
        if user_plan[u] != 2:
            continue
        d = rand_date(ABO_START, ABO_END)
        if age_on(user_birth[u], d) < film_limit[forced_film]:
            continue
        w.writerow([tid, fmt(d), u, forced_film, NULL])
        tid += 1
        forced_count -= 1
    while tid <= N_TELECH:
        u = random.randint(1, N_USERS)
        if user_plan[u] != 2:
            continue
        d = rand_date(ABO_START, ABO_END)
        if random.random() < 0.5:
            fid = random.randint(1, N_FILMS)
            limite = film_limit[fid]
            eid_val = NULL
            fid_val = fid
        else:
            eid_tmp, sid = random.choice(episodes)
            limite = serie_limit[sid]
            fid_val = NULL
            eid_val = eid_tmp
        if age_on(user_birth[u], d) < limite:
            continue
        w.writerow([tid, fmt(d), u, fid_val, eid_val])
        tid += 1

print("OK: CSV générés")
