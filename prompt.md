Today's date is {{TODAY}}. Search the web for the most important AI news from the past 7 days ({{WEEK_AGO}} to {{TODAY}}). Do NOT include any news published before {{WEEK_AGO}}.

Use multiple search queries to ensure broad coverage across these areas:

- New model releases and benchmarks
- Research breakthroughs and notable papers
- Industry news (funding, acquisitions, product launches, partnerships)
- AI policy, regulation, and safety developments
- Open source releases and community developments

Run at least 3-4 different web searches to cover these topics thoroughly.

From the results, select the 5-10 most noteworthy items. For each item:
- Write a concise but informative summary (2-3 sentences)
- Include the actual source URL from the search results
- Categorize it as one of: Models, Research, Industry, Policy, Open Source, Other

IMPORTANT: Every item MUST come from an actual web search result. Do NOT hallucinate or fabricate any news items, URLs, or sources. If you cannot find enough real news, return fewer items rather than making things up.

Return structured JSON only. No commentary or explanation outside the JSON. Use exactly this format:

```json
{
  "items": [
    {
      "title": "Short headline of the news item",
      "summary": "2-3 sentence summary of the news.",
      "source_url": "https://example.com/article",
      "category": "Models"
    }
  ],
  "search_date": "2025-02-16",
  "item_count": 1
}
```

- `category` must be one of: Models, Research, Industry, Policy, Open Source, Other
- `search_date` must be today's date in YYYY-MM-DD format
- `item_count` must match the number of items in the array
