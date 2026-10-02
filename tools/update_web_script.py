#!/usr/bin/env python3
import json

with open("tools/levels_data.json", "r") as f:
    all_20 = json.load(f)

# Format levels string
js_levels_str = "const levels = [\n"
for idx, lvl in enumerate(all_20):
    rows_str = ",\n    ".join([json.dumps(row) for row in lvl])
    js_levels_str += f"    // Realm {idx+1}\n    [\n    {rows_str}\n    ]" + (",\n" if idx < len(all_20)-1 else "\n")
js_levels_str += "];\n"

script_code = f"""const canvas = document.getElementById('gameCanvas');
const ctx = canvas.getContext('2d');

// UI Elements
const hud = document.getElementById('hud');
const overlay = document.getElementById('overlay');
const titleText = document.getElementById('titleText');
const subText = document.getElementById('subText');
const authorText = document.getElementById('authorText');
const levelVal = document.getElementById('levelVal');
const scoreVal = document.getElementById('scoreVal');
const livesVal = document.getElementById('livesVal');
const energyFill = document.getElementById('energyFill');
const gameContainer = document.getElementById('game-container');
const overlayActionBtn = document.getElementById('overlayActionBtn');
const blinkPrompt = document.getElementById('blinkPrompt');
const hudPauseBtn = document.getElementById('hudPauseBtn');
const deckPauseBtn = document.getElementById('deckPauseBtn');
const hudMusicBtn = document.getElementById('musicToggleBtn');
const deckMusicBtn = document.getElementById('deckMusicBtn');
const deckSlowBtn = document.getElementById('deckSlowBtn');
const dpadBase = document.getElementById('dpadBase');
const btnUp = document.getElementById('btnUp');
const btnDown = document.getElementById('btnDown');
const btnLeft = document.getElementById('btnLeft');
const btnRight = document.getElementById('btnRight');

// Game Constants
const TILE_SIZE = 25;
const LEVEL_WIDTH = 32;
const LEVEL_HEIGHT = 24;
const FPS = 50;

// Levels (32x24) - 20 Heavenly Realms with Angels
{js_levels_str}

// Game State Enum
const STATE_TITLE = 0;
const STATE_PLAYING = 1;
const STATE_PAUSED = 2;
const STATE_GAMEOVER = 3;
const STATE_LEVELWIN = 4;

let gameState = STATE_TITLE;
let currentLevel = 0;
let score = 0;
let keys = {{}};
let particles = [];

// Player
const player = {{
    x: 2,
    y: 20,
    lives: 3,
    invincible: 0,
    moveCooldown: 0
}};

// Chrono (Time mechanics)
const chrono = {{
    energy: 100,
    maxEnergy: 100,
    slowCost: 2,
    rechargeRate: 1,
    rechargeDelay: 4,
    timer: 0,
    isSlow: false
}};

// ===================================================
// Divine Web Audio MIDI Background Synthesizer
// ===================================================
class HeavenMidiSynth {{
    constructor() {{
        this.ctx = null;
        this.isPlaying = false;
        this.isMuted = false;
        this.currentStep = 0;
        this.timerId = null;

        // Frequencies in Hz for Heavenly D-Major / B-Minor
        this.midiFreq = {{
            'G2': 98.00,  'A2': 110.00, 'B2': 123.47, 'D3': 146.83,
            'F#3': 185.00,'G3': 196.00, 'A3': 220.00, 'B3': 246.94,
            'C#4': 277.18,'D4': 293.66, 'E4': 329.63, 'F#4': 369.99,
            'G4': 392.00, 'A4': 440.00, 'B4': 493.88, 'C#5': 554.37,
            'D5': 587.33, 'E5': 659.25, 'F#5': 739.99, 'G5': 783.99,
            'A5': 880.00, 'B5': 987.77, 'D6': 1174.66
        }};

        // 32-step Divine Hymn chord progression & melody
        this.score = [
            {{ lead: 'F#4', arp: 'D4',  bass: 'D3' }},
            {{ lead: null,  arp: 'A4',  bass: null }},
            {{ lead: 'G4',  arp: 'D5',  bass: null }},
            {{ lead: null,  arp: 'F#4', bass: null }},
            {{ lead: 'A4',  arp: 'A4',  bass: 'D3' }},
            {{ lead: null,  arp: 'D5',  bass: null }},
            {{ lead: 'D5',  arp: 'F#4', bass: null }},
            {{ lead: null,  arp: 'A4',  bass: null }},

            {{ lead: 'C#5', arp: 'A3',  bass: 'A2' }},
            {{ lead: null,  arp: 'E4',  bass: null }},
            {{ lead: 'B4',  arp: 'A4',  bass: null }},
            {{ lead: null,  arp: 'C#5', bass: null }},
            {{ lead: 'A4',  arp: 'E4',  bass: 'A2' }},
            {{ lead: null,  arp: 'A4',  bass: null }},
            {{ lead: 'G4',  arp: 'C#5', bass: null }},
            {{ lead: null,  arp: 'E4',  bass: null }},

            {{ lead: 'F#4', arp: 'B3',  bass: 'B2' }},
            {{ lead: null,  arp: 'D4',  bass: null }},
            {{ lead: 'E4',  arp: 'F#4', bass: null }},
            {{ lead: null,  arp: 'B4',  bass: null }},
            {{ lead: 'D4',  arp: 'D4',  bass: 'B2' }},
            {{ lead: null,  arp: 'F#4', bass: null }},
            {{ lead: 'E4',  arp: 'B4',  bass: null }},
            {{ lead: null,  arp: 'D4',  bass: null }},

            {{ lead: 'F#4', arp: 'G3',  bass: 'G2' }},
            {{ lead: null,  arp: 'B3',  bass: null }},
            {{ lead: 'G4',  arp: 'D4',  bass: null }},
            {{ lead: null,  arp: 'G4',  bass: null }},
            {{ lead: 'A4',  arp: 'A3',  bass: 'A2' }},
            {{ lead: null,  arp: 'C#4', bass: null }},
            {{ lead: 'D5',  arp: 'E4',  bass: null }},
            {{ lead: null,  arp: 'A4',  bass: null }}
        ];
    }}

    initContext() {{
        if (!this.ctx) {{
            const AudioCtx = window.AudioContext || window.webkitAudioContext;
            if (AudioCtx) {{
                this.ctx = new AudioCtx();
                this.masterGain = this.ctx.createGain();
                this.masterGain.gain.setValueAtTime(0.35, this.ctx.currentTime);
                this.masterGain.connect(this.ctx.destination);
            }}
        }}
        if (this.ctx && this.ctx.state === 'suspended') {{
            this.ctx.resume();
        }}
    }}

    start() {{
        this.initContext();
        if (this.isPlaying || !this.ctx) return;
        this.isPlaying = true;
        this.currentStep = 0;
        this.scheduleNextStep();
    }}

    scheduleNextStep() {{
        if (!this.isPlaying || !this.ctx) return;

        const stepData = this.score[this.currentStep];
        const now = this.ctx.currentTime;
        const isSlow = chrono && chrono.isSlow;

        // Dynamic Slow Motion audio manipulation
        const stepDuration = isSlow ? 0.32 : 0.14;
        const pitchShift = isSlow ? 0.72 : 1.0;

        if (!this.isMuted) {{
            if (stepData.lead && this.midiFreq[stepData.lead]) {{
                this.playVoice(this.midiFreq[stepData.lead] * pitchShift, now, stepDuration * 1.8, 'triangle', 0.22);
            }}
            if (stepData.arp && this.midiFreq[stepData.arp]) {{
                this.playVoice(this.midiFreq[stepData.arp] * pitchShift * (isSlow ? 0.85 : 1.0), now, stepDuration * 0.9, 'sine', 0.12);
            }}
            if (stepData.bass && this.midiFreq[stepData.bass]) {{
                this.playVoice(this.midiFreq[stepData.bass] * pitchShift, now, stepDuration * 3.2, 'sine', 0.28);
            }}
        }}

        this.currentStep = (this.currentStep + 1) % this.score.length;
        this.timerId = setTimeout(() => this.scheduleNextStep(), stepDuration * 1000);
    }}

    playVoice(freq, startTime, duration, type, volume) {{
        try {{
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.type = type;
            osc.frequency.setValueAtTime(freq, startTime);

            gain.gain.setValueAtTime(0.0001, startTime);
            gain.gain.exponentialRampToValueAtTime(volume, startTime + 0.03);
            gain.gain.exponentialRampToValueAtTime(0.0001, startTime + duration);

            osc.connect(gain);
            gain.connect(this.masterGain);
            osc.start(startTime);
            osc.stop(startTime + duration + 0.05);
        }} catch(e) {{}}
    }}

    playAngelChime() {{
        this.initContext();
        if (this.isMuted || !this.ctx) return;
        const now = this.ctx.currentTime;
        // 4 sparkling ascending notes: D5, F#5, A5, D6
        const notes = [587.33, 739.99, 880.00, 1174.66];
        notes.forEach((freq, idx) => {{
            this.playVoice(freq, now + idx * 0.06, 0.45, 'triangle', 0.26);
        }});
    }}

    playTimeWarp() {{
        this.initContext();
        if (this.isMuted || !this.ctx) return;
        const now = this.ctx.currentTime;
        try {{
            const osc = this.ctx.createOscillator();
            const gain = this.ctx.createGain();
            osc.type = 'sine';
            osc.frequency.setValueAtTime(440, now);
            osc.frequency.exponentialRampToValueAtTime(140, now + 0.35);
            gain.gain.setValueAtTime(0.2, now);
            gain.gain.exponentialRampToValueAtTime(0.001, now + 0.38);
            osc.connect(gain);
            gain.connect(this.masterGain);
            osc.start(now);
            osc.stop(now + 0.4);
        }} catch(e) {{}}
    }}

    toggleMute() {{
        this.isMuted = !this.isMuted;
        return this.isMuted;
    }}
}}

const synth = new HeavenMidiSynth();

function updateMusicButtonUI(isMuted) {{
    const label = isMuted ? '🔇' : '🎵';
    if (hudMusicBtn) {{
        hudMusicBtn.innerText = label;
        hudMusicBtn.classList.toggle('muted', isMuted);
    }}
    if (deckMusicBtn) {{
        deckMusicBtn.querySelector('.btn-icon').innerText = label;
        deckMusicBtn.classList.toggle('muted', isMuted);
    }}
}}

function handleMusicToggle(e) {{
    if (e) {{
        e.stopPropagation();
        e.preventDefault();
    }}
    synth.initContext();
    synth.start();
    const muted = synth.toggleMute();
    updateMusicButtonUI(muted);
}}

if (hudMusicBtn) {{
    hudMusicBtn.addEventListener('click', handleMusicToggle);
    hudMusicBtn.addEventListener('touchstart', handleMusicToggle, {{ passive: false }});
}}

if (deckMusicBtn) {{
    deckMusicBtn.addEventListener('click', handleMusicToggle);
    deckMusicBtn.addEventListener('touchstart', handleMusicToggle, {{ passive: false }});
}}

// Key Listeners
window.addEventListener('keydown', (e) => {{
    synth.initContext();
    synth.start();
    keys[e.key.toLowerCase()] = true;
    if (e.key === ' ' || e.key === 'Spacebar') keys['space'] = true;
    if (e.key.toLowerCase() === 'm') {{
        togglePause();
    }}
}});

window.addEventListener('keyup', (e) => {{
    keys[e.key.toLowerCase()] = false;
    if (e.key === ' ' || e.key === 'Spacebar') keys['space'] = false;
}});

function initGame() {{
    synth.initContext();
    synth.start();
    score = 0;
    player.lives = 3;
    currentLevel = 0;
    resetPlayer();
    chrono.energy = chrono.maxEnergy;
    setGameState(STATE_PLAYING);
}}

function resetPlayer() {{
    player.x = 2;
    player.y = 20;
    player.invincible = 0;
    player.moveCooldown = 0;
}}

function togglePause() {{
    if (gameState === STATE_PLAYING) {{
        setGameState(STATE_PAUSED);
    }} else if (gameState === STATE_PAUSED) {{
        setGameState(STATE_PLAYING);
    }}
}}

function setGameState(state) {{
    gameState = state;
    overlay.classList.remove('hidden');
    hud.style.display = 'none';

    const controlsPanel = document.querySelector('.controls-panel');
    const crossIcon = document.querySelector('.cross-icon');

    if (state === STATE_TITLE) {{
        titleText.innerText = "HEAVEN CHROME";
        subText.innerText = "A Divine Time-Bending Journey";
        subText.style.color = "#1e88e5";
        if (controlsPanel) controlsPanel.style.display = 'block';
        if (crossIcon) crossIcon.style.display = 'block';
        if (overlayActionBtn) {{
            overlayActionBtn.style.display = 'block';
            overlayActionBtn.innerText = "TAP TO ENTER PARADISE";
        }}
        if (blinkPrompt) blinkPrompt.innerText = "or press SPACE / tap screen to begin";
    }} else if (state === STATE_PLAYING) {{
        overlay.classList.add('hidden');
        hud.style.display = 'flex';
        synth.start();
    }} else if (state === STATE_PAUSED) {{
        titleText.innerText = "CONTEMPLATION";
        subText.innerText = "Journey Paused";
        subText.style.color = "#8B6508";
        if (controlsPanel) controlsPanel.style.display = 'none';
        if (crossIcon) crossIcon.style.display = 'none';
        if (overlayActionBtn) {{
            overlayActionBtn.style.display = 'block';
            overlayActionBtn.innerText = "RESUME JOURNEY";
        }}
        if (blinkPrompt) blinkPrompt.innerText = "or tap anywhere / press M";
    }} else if (state === STATE_GAMEOVER) {{
        titleText.innerText = "FALLEN";
        subText.innerText = "Your soul yearns to ascend again";
        subText.style.color = "#e53935";
        if (controlsPanel) controlsPanel.style.display = 'none';
        if (crossIcon) crossIcon.style.display = 'none';
        if (overlayActionBtn) {{
            overlayActionBtn.style.display = 'block';
            overlayActionBtn.innerText = "TAP TO RESURRECT";
        }}
        if (blinkPrompt) blinkPrompt.innerText = "or press SPACE / tap screen";
    }} else if (state === STATE_LEVELWIN) {{
        titleText.innerText = "ASCENSION";
        subText.innerText = `Ascending to Realm ${{currentLevel + 2}} of ${{levels.length}}...`;
        subText.style.color = "#FFD700";
        if (controlsPanel) controlsPanel.style.display = 'none';
        if (crossIcon) crossIcon.style.display = 'none';
        if (overlayActionBtn) overlayActionBtn.style.display = 'none';
        if (blinkPrompt) blinkPrompt.innerText = "";
        synth.playAngelChime();

        setTimeout(() => {{
            currentLevel++;
            if (currentLevel >= levels.length) {{
                gameState = STATE_GAMEOVER;
                titleText.innerText = "PARADISE FOUND";
                subText.innerText = "You have attained eternal peace!";
                subText.style.color = "#4caf50";
                if (overlayActionBtn) {{
                    overlayActionBtn.style.display = 'block';
                    overlayActionBtn.innerText = "PLAY AGAIN";
                }}
                overlay.classList.remove('hidden');
            }} else {{
                resetPlayer();
                setGameState(STATE_PLAYING);
            }}
        }}, 1800);
    }}
}}

// ------------------------------------------------------------------
// Touch and Click Event Handlers
// ------------------------------------------------------------------

function handleOverlayAction(e) {{
    if (e) {{
        e.stopPropagation();
        e.preventDefault();
    }}
    synth.initContext();
    synth.start();
    if (gameState === STATE_TITLE || gameState === STATE_GAMEOVER) {{
        initGame();
    }} else if (gameState === STATE_PAUSED) {{
        setGameState(STATE_PLAYING);
    }}
}}

if (overlayActionBtn) {{
    overlayActionBtn.addEventListener('click', handleOverlayAction);
    overlayActionBtn.addEventListener('touchstart', handleOverlayAction, {{ passive: false }});
}}

if (overlay) {{
    overlay.addEventListener('click', (e) => {{
        if (e.target !== overlayActionBtn) {{
            handleOverlayAction(e);
        }}
    }});
}}

// Pause Buttons
if (hudPauseBtn) {{
    hudPauseBtn.addEventListener('click', (e) => {{
        e.stopPropagation();
        togglePause();
    }});
    hudPauseBtn.addEventListener('touchstart', (e) => {{
        e.stopPropagation();
        e.preventDefault();
        togglePause();
    }}, {{ passive: false }});
}}

if (deckPauseBtn) {{
    deckPauseBtn.addEventListener('click', (e) => {{
        e.stopPropagation();
        togglePause();
    }});
    deckPauseBtn.addEventListener('touchstart', (e) => {{
        e.stopPropagation();
        e.preventDefault();
        togglePause();
    }}, {{ passive: false }});
}}

// Slow Time Button
function startSlowTime(e) {{
    if (e) e.preventDefault();
    synth.initContext();
    synth.start();
    keys['space'] = true;
    if (deckSlowBtn) deckSlowBtn.classList.add('pressed');
    synth.playTimeWarp();
    if (window.navigator && window.navigator.vibrate) {{
        try {{ window.navigator.vibrate(15); }} catch(err) {{}}
    }}
}}

function stopSlowTime(e) {{
    if (e) e.preventDefault();
    keys['space'] = false;
    if (deckSlowBtn) deckSlowBtn.classList.remove('pressed');
}}

if (deckSlowBtn) {{
    deckSlowBtn.addEventListener('touchstart', startSlowTime, {{ passive: false }});
    deckSlowBtn.addEventListener('touchend', stopSlowTime, {{ passive: false }});
    deckSlowBtn.addEventListener('touchcancel', stopSlowTime, {{ passive: false }});
    deckSlowBtn.addEventListener('mousedown', startSlowTime);
    deckSlowBtn.addEventListener('mouseup', stopSlowTime);
    deckSlowBtn.addEventListener('mouseleave', stopSlowTime);
}}

// D-Pad Touch & Drag Handlers
const dpadKeys = {{
    up: {{ el: btnUp, key1: 'w', key2: 'arrowup' }},
    down: {{ el: btnDown, key1: 's', key2: 'arrowdown' }},
    left: {{ el: btnLeft, key1: 'a', key2: 'arrowleft' }},
    right: {{ el: btnRight, key1: 'd', key2: 'arrowright' }}
}};

let activeDirection = null;

function setDirection(dir) {{
    if (activeDirection === dir) return;

    if (activeDirection && dpadKeys[activeDirection]) {{
        keys[dpadKeys[activeDirection].key1] = false;
        keys[dpadKeys[activeDirection].key2] = false;
        if (dpadKeys[activeDirection].el) dpadKeys[activeDirection].el.classList.remove('pressed');
    }}

    activeDirection = dir;

    if (dir && dpadKeys[dir]) {{
        synth.initContext();
        synth.start();
        keys[dpadKeys[dir].key1] = true;
        keys[dpadKeys[dir].key2] = true;
        if (dpadKeys[dir].el) dpadKeys[dir].el.classList.add('pressed');
        if (window.navigator && window.navigator.vibrate) {{
            try {{ window.navigator.vibrate(8); }} catch(err) {{}}
        }}
    }}
}}

function clearDpad() {{
    setDirection(null);
}}

function handleDpadTouch(e) {{
    e.preventDefault();
    if (e.type === 'touchend' || e.type === 'touchcancel') {{
        if (e.touches.length === 0) {{
            clearDpad();
        }} else {{
            let inDpad = false;
            for (let i = 0; i < e.touches.length; i++) {{
                let touch = e.touches[i];
                let target = document.elementFromPoint(touch.clientX, touch.clientY);
                if (target && dpadBase && dpadBase.contains(target)) {{
                    let btn = target.closest('.dpad-key');
                    if (btn && btn.dataset.dir) {{
                        setDirection(btn.dataset.dir);
                        inDpad = true;
                        break;
                    }}
                }}
            }}
            if (!inDpad) clearDpad();
        }}
        return;
    }}

    for (let i = 0; i < e.touches.length; i++) {{
        let touch = e.touches[i];
        let target = document.elementFromPoint(touch.clientX, touch.clientY);
        if (target && dpadBase && dpadBase.contains(target)) {{
            let btn = target.closest('.dpad-key');
            if (btn && btn.dataset.dir) {{
                setDirection(btn.dataset.dir);
                return;
            }}
        }}
    }}
}}

if (dpadBase) {{
    dpadBase.addEventListener('touchstart', handleDpadTouch, {{ passive: false }});
    dpadBase.addEventListener('touchmove', handleDpadTouch, {{ passive: false }});
    dpadBase.addEventListener('touchend', handleDpadTouch, {{ passive: false }});
    dpadBase.addEventListener('touchcancel', handleDpadTouch, {{ passive: false }});
}}

['up', 'down', 'left', 'right'].forEach(dir => {{
    let btn = dpadKeys[dir]?.el;
    if (btn) {{
        btn.addEventListener('mousedown', (e) => {{
            e.preventDefault();
            setDirection(dir);
        }});
        btn.addEventListener('mouseup', (e) => {{
            e.preventDefault();
            if (activeDirection === dir) clearDpad();
        }});
        btn.addEventListener('mouseleave', (e) => {{
            if (activeDirection === dir) clearDpad();
        }});
    }}
}});

// ------------------------------------------------------------------
// Game Logic and Rendering
// ------------------------------------------------------------------

function spawnParticles(x, y, color) {{
    for (let i = 0; i < 15; i++) {{
        particles.push({{
            x: (x * TILE_SIZE) + TILE_SIZE/2,
            y: (y * TILE_SIZE) + TILE_SIZE/2,
            vx: (Math.random() - 0.5) * 5,
            vy: (Math.random() - 0.5) * 5,
            life: 1.0,
            color: color
        }});
    }}
}}

function updateParticles() {{
    for (let i = particles.length - 1; i >= 0; i--) {{
        let p = particles[i];
        p.x += p.vx;
        p.y += p.vy;
        p.life -= 0.05;
        if (p.life <= 0) {{
            particles.splice(i, 1);
        }}
    }}
}}

function drawParticles() {{
    for (let p of particles) {{
        ctx.fillStyle = p.color;
        ctx.globalAlpha = p.life;
        ctx.beginPath();
        ctx.arc(p.x, p.y, 3, 0, Math.PI * 2);
        ctx.fill();
    }}
    ctx.globalAlpha = 1.0;
}}

function update() {{
    if (gameState === STATE_TITLE || gameState === STATE_GAMEOVER) {{
        if (keys['space']) {{
            keys['space'] = false;
            initGame();
        }}
        return;
    }}

    if (gameState !== STATE_PLAYING) return;

    // Chrono logic
    if (keys['space'] && chrono.energy >= chrono.slowCost) {{
        chrono.isSlow = true;
        chrono.energy -= chrono.slowCost;
        gameContainer.classList.add('time-slow');
    }} else {{
        chrono.isSlow = false;
        gameContainer.classList.remove('time-slow');
        chrono.timer++;
        if (chrono.timer >= chrono.rechargeDelay) {{
            chrono.timer = 0;
            if (chrono.energy < chrono.maxEnergy) {{
                chrono.energy += chrono.rechargeRate;
            }}
        }}
    }}

    // Player logic
    if (player.invincible > 0) player.invincible--;

    let moveSpeed = 1;
    let oldX = player.x;
    let oldY = player.y;

    if (!player.moveCooldown) player.moveCooldown = 0;

    if (player.moveCooldown > 0) {{
        player.moveCooldown--;
    }} else {{
        let moved = false;
        if ((keys['q'] || keys['w'] || keys['arrowup']) && player.y > 1) {{ player.y -= moveSpeed; moved = true; }}
        else if ((keys['s'] || keys['arrowdown']) && player.y < 22) {{ player.y += moveSpeed; moved = true; }}
        else if ((keys['o'] || keys['a'] || keys['arrowleft']) && player.x > 0) {{ player.x -= moveSpeed; moved = true; }}
        else if ((keys['p'] || keys['d'] || keys['arrowright']) && player.x < 31) {{ player.x += moveSpeed; moved = true; }}

        if (moved) player.moveCooldown = 4;
    }}

    // Check collision
    let map = levels[currentLevel];
    let tileX = Math.floor(player.x);
    let tileY = Math.floor(player.y);
    let tile = map[tileY][tileX];

    if (tile === 1 || tile === 3) {{
        if (player.invincible === 0) {{
            player.lives--;
            spawnParticles(player.x, player.y, tile === 3 ? '#FF0000' : '#FFFFFF');
            if (player.lives <= 0) {{
                setGameState(STATE_GAMEOVER);
            }} else {{
                player.invincible = 50;
                player.x = 2;
                player.y = 20;
            }}
        }} else {{
            player.x = oldX;
            player.y = oldY;
        }}
    }} else if (tile === 4) {{
        spawnParticles(player.x, player.y, '#FFD700');
        score += 1000;
        setGameState(STATE_LEVELWIN);
    }} else if (tile === 5) {{
        // Divine Angel Encounter!
        map[tileY][tileX] = 0; // Collect blessing
        score += 500;
        chrono.energy = Math.min(chrono.maxEnergy, chrono.energy + 35);
        spawnParticles(player.x, player.y, '#FFD700');
        spawnParticles(player.x, player.y, '#FFFFFF');
        synth.playAngelChime();
    }}

    updateParticles();

    // Update UI
    if (levelVal) levelVal.innerText = `${{currentLevel + 1}}/${{levels.length}}`;
    scoreVal.innerText = score;
    livesVal.innerText = player.lives;
    energyFill.style.width = (chrono.energy / chrono.maxEnergy * 100) + '%';
}}

function drawLevel() {{
    let map = levels[currentLevel];
    for (let y = 0; y < LEVEL_HEIGHT; y++) {{
        for (let x = 0; x < LEVEL_WIDTH; x++) {{
            let tile = map[y][x];
            let px = x * TILE_SIZE;
            let py = y * TILE_SIZE;

            if (tile === 1) {{ // Wall (Marble/Gold blocks)
                ctx.fillStyle = '#f8f8f8';
                ctx.strokeStyle = '#FFD700';
                ctx.lineWidth = 1;
                ctx.fillRect(px, py, TILE_SIZE, TILE_SIZE);
                ctx.strokeRect(px, py, TILE_SIZE, TILE_SIZE);
            }} else if (tile === 2) {{ // Platform (Clouds)
                ctx.fillStyle = '#ffffff';
                ctx.beginPath();
                ctx.arc(px + 8, py + 15, 8, 0, Math.PI * 2);
                ctx.arc(px + 18, py + 15, 10, 0, Math.PI * 2);
                ctx.arc(px + 28, py + 18, 6, 0, Math.PI * 2);
                ctx.fill();
            }} else if (tile === 3) {{ // Hazard (Red Cross)
                ctx.fillStyle = '#FF0000';
                ctx.shadowBlur = 10;
                ctx.shadowColor = '#FF0000';
                ctx.fillRect(px + TILE_SIZE/2 - 3, py + 2, 6, TILE_SIZE - 4);
                ctx.fillRect(px + 4, py + 8, TILE_SIZE - 8, 6);
                ctx.shadowBlur = 0;
            }} else if (tile === 4) {{ // Exit (Pearly Gates)
                ctx.fillStyle = '#FFD700';
                ctx.shadowBlur = 15;
                ctx.shadowColor = '#FFD700';
                ctx.fillRect(px + 2, py + 2, 4, TILE_SIZE - 4);
                ctx.fillRect(px + TILE_SIZE - 6, py + 2, 4, TILE_SIZE - 4);
                ctx.beginPath();
                ctx.arc(px + TILE_SIZE/2, py + 8, TILE_SIZE/2 - 2, Math.PI, 0);
                ctx.fill();
                ctx.shadowBlur = 0;
            }} else if (tile === 5) {{ // Celestial Angel
                let floatOffset = Math.sin(Date.now() / 250 + (x * 7 + y * 13)) * 3;
                let ay = py + floatOffset;

                ctx.save();
                ctx.shadowBlur = 15;
                ctx.shadowColor = '#FFD700';

                // Golden Halo
                ctx.strokeStyle = '#FFE066';
                ctx.lineWidth = 1.5;
                ctx.beginPath();
                ctx.ellipse(px + TILE_SIZE/2, ay + 3, 6, 2.5, 0, 0, Math.PI * 2);
                ctx.stroke();

                // Wings
                ctx.fillStyle = 'rgba(255, 255, 255, 0.9)';
                let wingFlap = Math.sin(Date.now() / 200) * 2;
                ctx.beginPath();
                ctx.moveTo(px + TILE_SIZE/2 - 2, ay + 9);
                ctx.quadraticCurveTo(px + 1, ay + 2 + wingFlap, px + 2, ay + 12);
                ctx.quadraticCurveTo(px + 7, ay + 13, px + TILE_SIZE/2 - 2, ay + 11);
                ctx.moveTo(px + TILE_SIZE/2 + 2, ay + 9);
                ctx.quadraticCurveTo(px + TILE_SIZE - 1, ay + 2 + wingFlap, px + TILE_SIZE - 2, ay + 12);
                ctx.quadraticCurveTo(px + TILE_SIZE - 7, ay + 13, px + TILE_SIZE/2 + 2, ay + 11);
                ctx.fill();

                // Head
                ctx.fillStyle = '#FFFFFF';
                ctx.beginPath();
                ctx.arc(px + TILE_SIZE/2, ay + 8, 3.5, 0, Math.PI * 2);
                ctx.fill();

                // Robe
                ctx.fillStyle = '#FFF8DC';
                ctx.beginPath();
                ctx.moveTo(px + TILE_SIZE/2 - 3, ay + 11);
                ctx.lineTo(px + TILE_SIZE/2 + 3, ay + 11);
                ctx.lineTo(px + TILE_SIZE/2 + 5, ay + 21);
                ctx.lineTo(px + TILE_SIZE/2 - 5, ay + 21);
                ctx.closePath();
                ctx.fill();

                // Divine Star
                ctx.fillStyle = '#FFD700';
                ctx.beginPath();
                ctx.arc(px + TILE_SIZE/2, ay + 14, 1.5, 0, Math.PI * 2);
                ctx.fill();

                ctx.restore();
            }}
        }}
    }}
}}

function drawPlayer() {{
    if (player.invincible > 0 && Math.floor(Date.now() / 100) % 2 === 0) return;

    let px = player.x * TILE_SIZE;
    let py = player.y * TILE_SIZE;

    ctx.fillStyle = '#ffffff';
    ctx.shadowBlur = 20;
    ctx.shadowColor = '#FFD700';

    ctx.beginPath();
    ctx.arc(px + TILE_SIZE/2, py + TILE_SIZE/2, TILE_SIZE/2 - 4, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = '#FFD700';
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.ellipse(px + TILE_SIZE/2, py + 4, 8, 3, 0, 0, Math.PI * 2);
    ctx.stroke();

    ctx.shadowBlur = 0;
}}

function draw() {{
    ctx.clearRect(0, 0, canvas.width, canvas.height);

    if (gameState === STATE_TITLE) {{
        return;
    }}

    drawLevel();
    drawPlayer();
    drawParticles();
}}

function gameLoop() {{
    update();
    draw();

    let delay = chrono.isSlow ? 1000/25 : 1000/FPS;
    setTimeout(gameLoop, delay);
}}

// Initialize
setGameState(STATE_TITLE);
gameLoop();
"""

with open("web/script.js", "w") as f:
    f.write(script_code)

print("web/script.js successfully updated with MIDI background music and Angels!")
