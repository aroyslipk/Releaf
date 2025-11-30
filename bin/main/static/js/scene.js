const scene = {
    rotation: { x: 0, y: 0 },
    position: { x: 0, y: 0, z: 0 },
    mouse: { x: 0, y: 0, down: false function animate() {
    // Apply momentum and friction
    if (!scene.mouse.down && !scene.touch.down) {
        scene.momentum.x *= scene.friction;
        scene.momentum.y *= scene.friction;
        scene.rotation.y += scene.momentum.x;
        scene.rotation.x += scene.momentum.y;
    }

    // Limit rotation
    scene.rotation.x = Math.max(-30, Math.min(30, scene.rotation.x));
    
    // Update hero section
    const hero = document.querySelector('.hero');
    if (hero) {
        const heroContent = document.querySelector('.hero-content');
        if (heroContent) {
            heroContent.style.transform = `
                perspective(2000px)
                rotateX(${scene.rotation.x}deg)
                rotateY(${scene.rotation.y}deg)
                translateZ(50px)
            `;x: 0, y: 0, down: false },
    speed: { rotation: 0.5, position: 1 },
    momentum: { x: 0, y: 0 },
    friction: 0.95
};

let heroScene = {
    x: 0,
    y: 0,
    targetX: 0,
    targetY: 0,
    rotationX: 0,
    rotationY: 0,
    parallaxItems: []
};

class ParallaxItem {
    constructor(element, depth) {
        this.element = element;
        this.depth = depth;
        this.x = 0;
        this.y = 0;
        this.rotation = 0;
        this.scale = 1;
    }

    update(cursorX, cursorY) {
        const rect = this.element.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;
        
        const deltaX = (cursorX - centerX) * 0.01 * this.depth;
        const deltaY = (cursorY - centerY) * 0.01 * this.depth;
        
        this.x += (deltaX - this.x) * 0.1;
        this.y += (deltaY - this.y) * 0.1;
        this.rotation += (deltaX * 0.05 - this.rotation) * 0.1;
        
        this.element.style.transform = `
            translate3d(${this.x}px, ${this.y}px, ${this.depth * 50}px)
            rotateX(${-this.y * 0.2}deg)
            rotateY(${this.x * 0.2}deg)
            rotateZ(${this.rotation}deg)
            scale(${1 + Math.abs(this.depth) * 0.05})
        `;
    }
}

// Initialize floating leaves
function createFloatingLeaves() {
    const hero = document.querySelector('.hero');
    const numLeaves = 20;
    
    for (let i = 0; i < numLeaves; i++) {
        const leaf = document.createElement('div');
        leaf.className = 'scene-leaf';
        leaf.style.left = `${Math.random() * 100}%`;
        leaf.style.top = `${Math.random() * 100}%`;
        hero.appendChild(leaf);
        
        heroScene.parallaxItems.push(new ParallaxItem(leaf, (Math.random() - 0.5) * 2));
    }
}

// Mouse and touch interaction handlers
document.addEventListener('mousedown', (e) => {
    scene.mouse.down = true;
    scene.mouse.x = e.clientX;
    scene.mouse.y = e.clientY;
});

document.addEventListener('mousemove', (e) => {
    if (scene.mouse.down) {
        const deltaX = e.clientX - scene.mouse.x;
        const deltaY = e.clientY - scene.mouse.y;
        
        scene.momentum.x = deltaX * scene.speed.rotation;
        scene.momentum.y = deltaY * scene.speed.rotation;
        
        scene.rotation.y += scene.momentum.x;
        scene.rotation.x += scene.momentum.y;
        
        scene.mouse.x = e.clientX;
        scene.mouse.y = e.clientY;
    }
});

document.addEventListener('mouseup', () => {
    scene.mouse.down = false;
});

document.addEventListener('touchstart', (e) => {
    scene.touch.down = true;
    scene.touch.x = e.touches[0].clientX;
    scene.touch.y = e.touches[0].clientY;
});

document.addEventListener('touchmove', (e) => {
    if (scene.touch.down) {
        const deltaX = e.touches[0].clientX - scene.touch.x;
        const deltaY = e.touches[0].clientY - scene.touch.y;
        
        scene.momentum.x = deltaX * scene.speed.rotation;
        scene.momentum.y = deltaY * scene.speed.rotation;
        
        scene.rotation.y += scene.momentum.x;
        scene.rotation.x += scene.momentum.y;
        
        scene.touch.x = e.touches[0].clientX;
        scene.touch.y = e.touches[0].clientY;
    }
});

document.addEventListener('touchend', () => {
    scene.touch.down = false;
});

// 3D Scene Animation
function animate() {
    // Smooth cursor movement
    cursor.x += (cursor.targetX - cursor.x) * cursor.speed;
    cursor.y += (cursor.targetY - cursor.y) * cursor.speed;

    // Calculate hero scene movement
    const hero = document.querySelector('.hero');
    if (hero) {
        const rect = hero.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;

        heroScene.targetX = (cursor.x - centerX) * 0.02;
        heroScene.targetY = (cursor.y - centerY) * 0.02;

        heroScene.x += (heroScene.targetX - heroScene.x) * 0.1;
        heroScene.y += (heroScene.targetY - heroScene.y) * 0.1;

        // Apply rotations
        heroScene.rotationX += (heroScene.targetY * 0.05 - heroScene.rotationX) * 0.1;
        heroScene.rotationY += (heroScene.targetX * 0.05 - heroScene.rotationY) * 0.1;

        const heroContent = document.querySelector('.hero-content');
        if (heroContent) {
            heroContent.style.transform = `
                translate3d(${heroScene.x}px, ${heroScene.y}px, 50px)
                rotateX(${-heroScene.rotationX}deg)
                rotateY(${heroScene.rotationY}deg)
            `;
        }

        // Update parallax items
        heroScene.parallaxItems.forEach(item => {
            item.update(cursor.x, cursor.y);
        });
    }

    // Animate impact cards with 3D effect
    document.querySelectorAll('.impact-card').forEach((card, index) => {
        const rect = card.getBoundingClientRect();
        const centerX = rect.left + rect.width / 2;
        const centerY = rect.top + rect.height / 2;
        
        const deltaX = (cursor.x - centerX) * 0.01;
        const deltaY = (cursor.y - centerY) * 0.01;
        const speed = 1 + index * 0.2;
        
        const yMovement = Math.sin(Date.now() * 0.001 * speed) * 15;
        const rotation = Math.cos(Date.now() * 0.001 * speed) * 2;
        
        card.style.transform = `
            translate3d(${deltaX * 2}px, ${deltaY * 2 + yMovement}px, 20px)
            rotateX(${-deltaY}deg)
            rotateY(${deltaX}deg)
            rotate(${rotation}deg)
        `;
    });

    requestAnimationFrame(animate);
}

// Impact counter animation
function animateImpactCounters() {
    const counters = document.querySelectorAll('.impact-number');
    counters.forEach(counter => {
        const target = parseFloat(counter.getAttribute('data-target'));
        const suffix = counter.getAttribute('data-suffix');
        let current = 0;
        const increment = target / 100;
        const duration = 2000;
        const stepTime = duration / 100;

        const updateCounter = () => {
            current += increment;
            if (current >= target) {
                counter.textContent = target.toLocaleString() + suffix;
            } else {
                counter.textContent = Math.floor(current).toLocaleString() + suffix;
                setTimeout(updateCounter, stepTime);
            }
        };

        const observer = new IntersectionObserver((entries) => {
            if (entries[0].isIntersecting) {
                updateCounter();
                observer.unobserve(counter);
            }
        });

        observer.observe(counter);
    });
}

// Initialize all animations
document.addEventListener('DOMContentLoaded', () => {
    // Create floating leaves in the background
    createFloatingLeaves();
    
    // Start the animation loop
    animate();
    animateImpactCounters();

    // Add parallax depth to key elements
    const contentElements = document.querySelectorAll('.hero h1, .hero p, .hero .cta-button');
    contentElements.forEach((element, index) => {
        heroScene.parallaxItems.push(new ParallaxItem(element, 0.5 - index * 0.1));
    });

    // Make sure buttons are clickable
    document.querySelectorAll('.cta-button').forEach(button => {
        button.addEventListener('click', (e) => {
            const href = button.getAttribute('href');
            if (href) {
                window.location.href = href;
            }
        });
    });

    // Add smooth parallax on scroll
    let lastScrollY = window.scrollY;
    window.addEventListener('scroll', () => {
        const scrollDelta = window.scrollY - lastScrollY;
        heroScene.parallaxItems.forEach(item => {
            item.y -= scrollDelta * item.depth * 0.1;
        });
        lastScrollY = window.scrollY;
    });
});
