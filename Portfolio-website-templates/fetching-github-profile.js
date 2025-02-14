// Fetch GitHub Projects
async function fetchProjects() {
    try {
        const response = await fetch('https://api.github.com/users/YOUR_GITHUB_USERNAME/repos');
        const projects = await response.json();
        
        const container = document.getElementById('projects-container');
        
        projects.forEach(project => {
            const card = document.createElement('div');
            card.className = 'project-card';
            card.innerHTML = `
                <h3>${project.name}</h3>
                <p>${project.description || 'No description'}</p>
                <p>Language: ${project.language || 'N/A'}</p>
                <a href="${project.html_url}" target="_blank">View on GitHub</a>
            `;
            container.appendChild(card);
        });
    } catch (error) {
        console.error('Error fetching projects:', error);
    }
}

// Form Submission
document.getElementById('contactForm').addEventListener('submit', (e) => {
    e.preventDefault();
    // Add your form submission logic here
    alert('Message sent successfully!');
    e.target.reset();
});

// Smooth Scroll
document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        document.querySelector(this.getAttribute('href')).scrollIntoView({
            behavior: 'smooth'
        });
    });
});

// Initial fetch
fetchProjects();
