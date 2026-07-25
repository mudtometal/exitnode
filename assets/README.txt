EXIT NODE — asset drop points
=============================

assets/logo.svg           → your devil-girl mark. Then in index.html replace the
                            .logo-box div with: <img src="assets/logo.svg" alt="EXIT NODE">
assets/landing.mp4        → landing feed. Muted loop, h264 mp4, ideally under ~8MB,
                            grainy/low-fps reads best (site applies grayscale + dim).
assets/landing-poster.jpg → still frame shown before video loads / on mobile data saver.
assets/cyvist-01.jpg ...  → entry plates. Replace .plate divs with <img class="plate" ...>.

No build step. Open index.html in a browser, or host anywhere static
(Vercel, Netlify, GitHub Pages, plain FTP).
