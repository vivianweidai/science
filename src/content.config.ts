import { defineCollection, z } from 'astro:content';
import { glob } from 'astro/loaders';

const projects = defineCollection({
  loader: glob({
    pattern: '*/index.md',
    base: './public/research/projects',
    // Preserve the original folder name as the id so URLs like
    // /research/projects/20260420%20UV-Vis%20Spectroscopy/ keep working.
    generateId: ({ entry }) => entry.replace(/\/index\.md$/, ''),
  }),
  schema: z.object({
    project: z.string(),
    // H1 prose title. Rendered by Project.astro at the top of the page.
    title: z.string(),
    // Full science name(s) — drives chip rendering at the title row,
    // toy-page reverse-lookup, and project-page subject coloring.
    sciences: z.array(z.string()),
    // Render the Mi cat icon next to the H1 — only the two cat-themed
    // projects use this.
    mi: z.boolean().optional(),
    data_photos: z.array(z.string()).optional(),
    // Toys this project uses. Drives the auto-populated Projects section
    // on each /research/toys/<sci>/<Toy>/ page.
    toys: z.array(z.string()).optional(),
  }),
});

// Per-toy template pages — one folder per toy under
// public/research/toys/<science_slug>/<Toy Name>/index.md.
// id is "<science_slug>/<toy>" so the dynamic route can split params.
const toys = defineCollection({
  loader: glob({
    pattern: '*/*/index.md',
    base: './public/research/toys',
    generateId: ({ entry }) => entry.replace(/\/index\.md$/, ''),
  }),
  schema: z.object({
    toy: z.string(),
    science: z.string(),
    science_slug: z.string(),
    topic: z.string(),
    technology: z.string(),
    hero: z.string().optional(),
    // Optional CSS object-position override for cropping the hero (e.g.
    // "top" or "center 30%"). Default is center; tweak when the
    // important part of the image is off-center.
    hero_position: z.string().optional(),
    // Physical instruments this toy maps to. Rendered as the Technology
    // list on the toy page; if the toy is referenced by any project, each
    // instrument's name links to the most recent matching project.
    instruments: z.array(z.object({
      name: z.string(),
      description: z.string(),
    })).optional(),
    // Placeholder projects that don't have a local project page yet —
    // rendered in the Projects section alongside reverse-lookup hits.
    // Each entry: { date: "YYYY-MM-DD", title, url (external), science (full) }.
    extra_projects: z.array(z.object({
      date: z.string(),
      title: z.string(),
      url: z.string(),
      sciences: z.array(z.string()),
    })).optional(),
  }),
});

export const collections = { projects, toys };
