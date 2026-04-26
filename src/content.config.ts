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
    title: z.string().optional(),
    data_photos: z.array(z.string()).optional(),
  }),
});

// Chinese mirror of projects — sibling .zh.md files in the same folders,
// surfaced at /zh/research/projects/<folder>/.
const zhProjects = defineCollection({
  loader: glob({
    pattern: '*/index.zh.md',
    base: './public/research/projects',
    generateId: ({ entry }) => entry.replace(/\/index\.zh\.md$/, ''),
  }),
  schema: z.object({
    project: z.string(),
    title: z.string().optional(),
  }),
});

export const collections = { projects, zhProjects };
