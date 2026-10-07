// Replace with your GitHub username.
const GITHUB_USERNAME = 'YOUR_GITHUB_USERNAME';

// Build a card with textContent only: API data is never parsed as HTML (prevents XSS).
function createProjectCard(project) {
    const card = document.createElement('div');
    card.className = 'project-card';

    const title = document.createElement('h3');
    title.textContent = project.name;

    const description = document.createElement('p');
    description.textContent = project.description || 'No description';

    const language = document.createElement('p');
    language.textContent = `Language: ${project.language || 'N/A'}`;

    const link = document.createElement('a');
    link.href = project.html_url;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    link.textContent = 'View on GitHub';

    card.append(title, description, language, link);
    return card;
}

// Fetch GitHub Projects
async function fetchProjects() {
    const container = document.getElementById('projects-container');

    try {
        const response = await fetch(
            `https://api.github.com/users/${encodeURIComponent(GITHUB_USERNAME)}/repos?sort=updated&per_page=12`,
            { headers: { Accept: 'application/vnd.github+json' } }
        );
        if (!response.ok) {
            throw new Error(`GitHub API responded with ${response.status}`);
        }

        const projects = await response.json();
        container.replaceChildren(...projects.map(createProjectCard));
    } catch (error) {
        console.error('Error fetching projects:', error);
        const message = document.createElement('p');
        message.textContent = 'Projects could not be loaded right now.';
        container.replaceChildren(message);
    }
}

// Form submission (placeholder: connect to your backend or a form service)
document.getElementById('contactForm').addEventListener('submit', (e) => {
    e.preventDefault();
    document.getElementById('form-status').textContent =
        'Thanks! This template form is not connected to a backend yet.';
    e.target.reset();
});

// Smooth scroll
document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener('click', (e) => {
        const target = document.querySelector(anchor.getAttribute('href'));
        if (!target) return;
        e.preventDefault();
        target.scrollIntoView({ behavior: 'smooth' });
    });
});

fetchProjects();
