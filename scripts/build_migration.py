#!/usr/bin/env python3
"""Regenerate migrations/0001_initial.sql from archives/*.csv.

Run whenever the CSVs change. After running:
    npx wrangler d1 execute science --remote --file=./migrations/0001_initial.sql
"""
import csv
from pathlib import Path

MONTHS = {m:i for i,m in enumerate(
  ["January","February","March","April","May","June",
   "July","August","September","October","November","December"], start=1)}

def sort_key(date: str) -> str:
    if date == 'Future':
        return '9999-12'
    parts = date.split()
    if len(parts) != 2:
        return '0000-00'
    month, year = parts
    return f"{int(year):04d}-{MONTHS.get(month,0):02d}"

def sql_str(s: str) -> str:
    return "'" + s.replace("'", "''") + "'"

def main():
    root = Path(__file__).resolve().parent.parent
    out = [
        "-- Initial seed data from archives/*.csv",
        "-- Generated — do not edit by hand; rerun scripts/build_migration.py",
        "",
        "DELETE FROM olympiads;",
        "DELETE FROM textbooks;",
        "",
    ]

    with open(root/'archives/olympiads.csv') as f:
        for row in csv.DictReader(f):
            vals = [
                sql_str(row['Subject']),
                sql_str(row['Date']),
                sql_str(sort_key(row['Date'])),
                sql_str(row['Country']),
                sql_str(row['Olympiad']),
                '1' if row['Finished']=='Yes' else '0',
                '1' if row['Highlighted']=='Yes' else '0',
            ]
            out.append(
                "INSERT INTO olympiads (subject,date,sort_key,country,name,finished,highlighted) "
                f"VALUES ({','.join(vals)});"
            )

    out.append("")
    with open(root/'archives/textbooks.csv') as f:
        for row in csv.DictReader(f):
            vals = [
                sql_str(row['Subject']),
                sql_str(row['Date']),
                sql_str(sort_key(row['Date'])),
                sql_str(row['Textbook']),
                '1' if row['Finished']=='Yes' else '0',
                '1' if row['Highlighted']=='Yes' else '0',
            ]
            out.append(
                "INSERT INTO textbooks (subject,date,sort_key,title,finished,highlighted) "
                f"VALUES ({','.join(vals)});"
            )

    (root/'migrations').mkdir(exist_ok=True)
    (root/'migrations/0001_initial.sql').write_text('\n'.join(out) + '\n')
    inserts = sum(1 for l in out if l.startswith('INSERT'))
    print(f"Wrote {inserts} INSERT rows to migrations/0001_initial.sql")

if __name__ == '__main__':
    main()
