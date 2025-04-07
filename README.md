# Tech Layoffs SQL EDA

This project explores trends in global tech layoffs using SQL. The goal was to dig into the data and uncover patterns around which companies, countries, and industries were hit hardest, and how layoffs have changed over time.

---

## What's Included

The repository contains a full SQL script (`layoffs_eda.sql`) that covers:

- Basic statistics like maximum layoffs and full company shutdowns
- Aggregated summaries by company, location, country, and industry
- Year-over-year breakdowns and monthly trends
- Ranking of top companies by layoffs per year using window functions
- Rolling totals to visualize how layoffs accumulated over time
- Proportion of global layoffs by country

---

## Key Takeaways

- Several companies laid off 100% of their workforce — most of them startups.
- Some of the highest-funded companies also saw major layoffs.
- Layoffs peaked during certain periods, possibly due to post-pandemic corrections or economic shifts.
- The majority of layoffs came from a small number of countries and industries.

---

## Tools Used

- MySQL (8.x)
- Common table expressions (CTEs)
- Window functions
- Aggregations and date-based grouping

---

## Dataset

The dataset used for this project tracks global layoffs in the tech industry. It was compiled from publicly available sources. If you're using your own version of the data, make sure to update the table names in the queries accordingly.

---

## How to Use

1. Clone the repository
2. Import your layoff dataset into MySQL
3. Run `layoffs_eda.sql` to explore the data

Feel free to modify or extend the queries for deeper insights.

---

## Contributing

Suggestions, improvements, or new ideas for exploration are always welcome. Feel free to fork the repo or open an issue if you’d like to collaborate.

---

## Contact

If you're working on a similar project or interested in data analysis, feel free to reach out.
