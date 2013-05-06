# Welcome!
This is the primary repository for the BaconBounty website application built using Haskell and the Snap framework. This
application may use snaplets in other repositories within this organization on GitHub.

## Design Choices

### Hakyll

I've chosen to go with a static site compiler for public-facing "pages" that Google may crawl and so they are easy to
change too. They serve out of the Snap heist directory directly negating the need to overwrite the extensions.

### Backbone

I'm using backbone.js for the backend application with NO fallback planned and marrionette as a top layer. I am
considering the possibility of doing fallback - but I don't really think it's necessary for the backend. The frontend
should consist entirely of static pages built w/ Hakyll to be SEO compliant.

### Color Scheme
http://www.colourlovers.com/palette/209701/Burning_Angel

### Ideas

I would love to use pixel art throughout the site - maybe even some isometric art in the design? Another fun idea is to
create my own IconFont of pixel-art piggies dancing, theiving, socializing that can be used to drop easter eggs. Maybe a
"the last supper" iso-art relief (or something appropriate to what BaconBounty is?).
