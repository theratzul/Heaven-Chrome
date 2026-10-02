const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

// UI Elements
const hud = document.getElementById('hud');
const overlay = document.getElementById('overlay');
const titleText = document.getElementById('titleText');
const subText = document.getElementById('subText');
const scoreVal = document.getElementById('scoreVal');
const livesVal = document.getElementById('livesVal');
const energyFill = document.getElementById('energyFill');
const gameContainer = document.getElementById('game-container');

// Game Constants
const TILE_SIZE = 25;
const LEVEL_WIDTH = 32;
const LEVEL_HEIGHT = 24;
const FPS = 50;

// Levels (32x24) - Matching original C code
const level1_data = [
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
];

const level2_data = [
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,1,3,3,3,3,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,1],
    [1,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,0,0,2,2,2,2,2,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
];

const level3_data = [
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,2,0,0,0,0,3,3,3,3,0,0,0,0,0,2,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,3,3,0,0,0,0,0,3,3,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,0,0,0,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,2,0,0,0,0,1],
    [1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,2,2,2,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1],
    [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]
];

const levels = [level1_data, level2_data, level3_data];

// Game State Enum
const STATE_TITLE = 0;
const STATE_PLAYING = 1;
const STATE_PAUSED = 2;
const STATE_GAMEOVER = 3;
const STATE_LEVELWIN = 4;

let gameState = STATE_TITLE;
let currentLevel = 0;
let score = 0;
let keys = {};
let particles = [];
let gameLoopInterval;

// Player
const player = {
    x: 2,
    y: 20,
    lives: 3,
    invincible: 0,
    color: '#0f0'
};

// Chrono (Time mechanics)
const chrono = {
    energy: 100,
    maxEnergy: 100,
    slowCost: 2,
    rechargeRate: 1,
    rechargeDelay: 4,
    timer: 0,
    isSlow: false
};

// Key Listeners
window.addEventListener('keydown', (e) => {
    keys[e.key.toLowerCase()] = true;
    if (e.key === ' ' || e.key === 'Spacebar') keys['space'] = true;
    if (e.key.toLowerCase() === 'm' && gameState === STATE_PLAYING) {
        setGameState(STATE_PAUSED);
    } else if (e.key.toLowerCase() === 'm' && gameState === STATE_PAUSED) {
        setGameState(STATE_PLAYING);
    }
});
window.addEventListener('keyup', (e) => {
    keys[e.key.toLowerCase()] = false;
    if (e.key === ' ' || e.key === 'Spacebar') keys['space'] = false;
});

function initGame() {
    score = 0;
    player.lives = 3;
    currentLevel = 0;
    resetPlayer();
    chrono.energy = chrono.maxEnergy;
    setGameState(STATE_PLAYING);
}

function resetPlayer() {
    player.x = 2;
    player.y = 20;
    player.invincible = 0;
}

function setGameState(state) {
    gameState = state;
    overlay.classList.remove('hidden');
    hud.style.display = 'none';
    
    if (state === STATE_TITLE) {
        titleText.innerText = "CHRONOS";
        subText.innerText = "A Time-Bending Adventure";
        subText.style.color = "#f0f";
        document.querySelector('.controls').style.display = 'block';
    } else if (state === STATE_PLAYING) {
        overlay.classList.add('hidden');
        hud.style.display = 'flex';
    } else if (state === STATE_PAUSED) {
        titleText.innerText = "PAUSED";
        subText.innerText = "Press M to resume";
        document.querySelector('.controls').style.display = 'none';
    } else if (state === STATE_GAMEOVER) {
        titleText.innerText = "GAME OVER";
        subText.innerText = "Press SPACE to restart";
        document.querySelector('.controls').style.display = 'none';
    } else if (state === STATE_LEVELWIN) {
        titleText.innerText = "LEVEL CLEAR";
        subText.innerText = "Loading next sector...";
        document.querySelector('.controls').style.display = 'none';
        setTimeout(() => {
            currentLevel++;
            if (currentLevel >= levels.length) {
                gameState = STATE_GAMEOVER;
                titleText.innerText = "VICTORY";
                subText.innerText = "You have mastered time!";
                overlay.classList.remove('hidden');
            } else {
                resetPlayer();
                setGameState(STATE_PLAYING);
            }
        }, 2000);
    }
}

function spawnParticles(x, y, color) {
    for (let i = 0; i < 15; i++) {
        particles.push({
            x: (x * TILE_SIZE) + TILE_SIZE/2,
            y: (y * TILE_SIZE) + TILE_SIZE/2,
            vx: (Math.random() - 0.5) * 5,
            vy: (Math.random() - 0.5) * 5,
            life: 1.0,
            color: color
        });
    }
}

function updateParticles() {
    for (let i = particles.length - 1; i >= 0; i--) {
        let p = particles[i];
        p.x += p.vx;
        p.y += p.vy;
        p.life -= 0.05;
        if (p.life <= 0) {
            particles.splice(i, 1);
        }
    }
}

function drawParticles() {
    for (let p of particles) {
        ctx.fillStyle = p.color;
        ctx.globalAlpha = p.life;
        ctx.beginPath();
        ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
        ctx.fill();
    }
    ctx.globalAlpha = 1.0;
}

function update() {
    if (gameState === STATE_TITLE || gameState === STATE_GAMEOVER) {
        if (keys['space']) {
            keys['space'] = false; // consume
            initGame();
        }
        return;
    }

    if (gameState !== STATE_PLAYING) return;

    // Chrono logic
    if (keys['space'] && chrono.energy >= chrono.slowCost) {
        chrono.isSlow = true;
        chrono.energy -= chrono.slowCost;
        gameContainer.classList.add('time-slow');
    } else {
        chrono.isSlow = false;
        gameContainer.classList.remove('time-slow');
        chrono.timer++;
        if (chrono.timer >= chrono.rechargeDelay) {
            chrono.timer = 0;
            if (chrono.energy < chrono.maxEnergy) {
                chrono.energy += chrono.rechargeRate;
            }
        }
    }

    // Player logic
    if (player.invincible > 0) player.invincible--;

    let moveSpeed = 1; 
    let oldX = player.x;
    let oldY = player.y;
    
    // Throttle movement for a grid feel but smoother. We'll stick to original discrete movement.
    // Original game moved 1 char per frame. That's very fast at 50fps.
    // We will do a cooldown for movement to simulate the original feel better.
    if (!player.moveCooldown) player.moveCooldown = 0;
    
    if (player.moveCooldown > 0) {
        player.moveCooldown--;
    } else {
        let moved = false;
        if ((keys['q'] || keys['w'] || keys['arrowup']) && player.y > 1) { player.y -= moveSpeed; moved = true; }
        else if ((keys['a'] || keys['s'] || keys['arrowdown']) && player.y < 22) { player.y += moveSpeed; moved = true; }
        else if ((keys['o'] || keys['a'] || keys['arrowleft']) && player.x > 0) { player.x -= moveSpeed; moved = true; }
        else if ((keys['p'] || keys['d'] || keys['arrowright']) && player.x < 31) { player.x += moveSpeed; moved = true; }
        
        if (moved) player.moveCooldown = 4; // limit movement speed
    }

    // Check collision
    let map = levels[currentLevel];
    let tile = map[Math.floor(player.y)][Math.floor(player.x)];

    if (tile === 1 || tile === 3) {
        if (player.invincible === 0) {
            player.lives--;
            spawnParticles(player.x, player.y, '#f00');
            if (player.lives <= 0) {
                setGameState(STATE_GAMEOVER);
            } else {
                player.invincible = 50;
                player.x = 2; // spawn point
                player.y = 20;
            }
        } else {
            // bounce back
            player.x = oldX;
            player.y = oldY;
        }
    } else if (tile === 4) {
        spawnParticles(player.x, player.y, '#0f0');
        score += 1000;
        setGameState(STATE_LEVELWIN);
    }

    updateParticles();
    
    // Update UI
    scoreVal.innerText = score;
    livesVal.innerText = player.lives;
    energyFill.style.width = (chrono.energy / chrono.maxEnergy * 100) + '%';
}

function drawLevel() {
    let map = levels[currentLevel];
    for (let y = 0; y < LEVEL_HEIGHT; y++) {
        for (let x = 0; x < LEVEL_WIDTH; x++) {
            let tile = map[y][x];
            let px = x * TILE_SIZE;
            let py = y * TILE_SIZE;

            if (tile === 1) { // Wall
                ctx.fillStyle = '#055';
                ctx.strokeStyle = '#0ff';
                ctx.lineWidth = 1;
                ctx.fillRect(px, py, TILE_SIZE, TILE_SIZE);
                ctx.strokeRect(px, py, TILE_SIZE, TILE_SIZE);
            } else if (tile === 2) { // Platform
                ctx.fillStyle = '#505';
                ctx.fillRect(px, py + TILE_SIZE/2, TILE_SIZE, TILE_SIZE/2);
                ctx.fillStyle = '#f0f';
                ctx.fillRect(px, py + TILE_SIZE/2, TILE_SIZE, 2);
            } else if (tile === 3) { // Hazard
                ctx.fillStyle = '#f00';
                ctx.beginPath();
                ctx.moveTo(px + TILE_SIZE/2, py);
                ctx.lineTo(px + TILE_SIZE, py + TILE_SIZE);
                ctx.lineTo(px, py + TILE_SIZE);
                ctx.fill();
            } else if (tile === 4) { // Exit
                ctx.fillStyle = '#0f0';
                ctx.shadowBlur = 10;
                ctx.shadowColor = '#0f0';
                ctx.fillRect(px + 5, py + 5, TILE_SIZE - 10, TILE_SIZE - 10);
                ctx.shadowBlur = 0;
            }
        }
    }
}

function drawPlayer() {
    if (player.invincible > 0 && Math.floor(Date.now() / 100) % 2 === 0) return;

    let px = player.x * TILE_SIZE;
    let py = player.y * TILE_SIZE;

    ctx.fillStyle = player.color;
    ctx.shadowBlur = 15;
    ctx.shadowColor = player.color;
    
    ctx.beginPath();
    ctx.arc(px + TILE_SIZE/2, py + TILE_SIZE/2, TILE_SIZE/2 - 4, 0, Math.PI * 2);
    ctx.fill();
    
    ctx.shadowBlur = 0;
}

function draw() {
    // Clear
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    
    if (gameState === STATE_TITLE) {
        // Draw some background stuff
        return;
    }

    drawLevel();
    drawPlayer();
    drawParticles();
}

function gameLoop() {
    update();
    draw();
    
    // Slow down effect visual + logic
    let delay = chrono.isSlow ? 1000/25 : 1000/FPS;
    setTimeout(gameLoop, delay);
}

// Start
setGameState(STATE_TITLE);
gameLoop();
