// Tour analytics configuration — shared by the demo (index.html) and the dashboard
// (analytics.html). Fill in both values from your Supabase project (Settings → API).
// While either value is empty, the demo sends nothing and the dashboard shows a
// "not configured" notice; the prototype itself is unaffected either way.
window.TOUR_ANALYTICS_CONFIG = {
  url: '',      // e.g. 'https://abcdefghijkl.supabase.co'
  anonKey: '',  // the "anon public" key — safe to publish; the SQL policies make it append-only
};
