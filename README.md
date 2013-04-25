# Welcome!
This is the primary repository for the BaconBounty website application built using Haskell and the Snap framework. This
application may use snaplets in other repositories within this organization on GitHub.

## Design Choices

### Hakyll
I've chosen to go with a static site compiler for public-facing "pages" that Google may crawl and so they are easy to
change too. They serve out of the Snap heist directory directly negating the need to overwrite the extensions.

### Backbone
I'm using backbone.js for the backend application with NO fallback (sorry, it's the 21st century) and marrionette as a
top layer.

