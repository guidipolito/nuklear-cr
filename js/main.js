let links = [];
let headings = [];

function isVisibleInContainer(el, container) {
  const elRect = el.getBoundingClientRect();
  const containerRect = container.getBoundingClientRect();

  return (
    elRect.top >= containerRect.top &&
    elRect.bottom <= containerRect.bottom
  );
}

function updateActiveLink() {
  let activeHeading = null;

  for (const heading of headings) {
    // Adjust this offset to match your sticky header
    if (heading.getBoundingClientRect().top <= 180) {
      activeHeading = heading;
    } else {
      break;
    }
  }

  // If we're above the first heading
  activeHeading ??= headings[0];
  links.forEach((link) => link.classList.remove("fruti-toc-selected", "fruti-toc-before"));

  if (!activeHeading) return;

  let id = '#'+activeHeading.id
  console.log(id)
  links.find(el=>{ 
    if(el.hash == id){
      el.classList.add("fruti-toc-selected")
      if(!isVisibleInContainer(el, el.closest(".md-sidebar__scrollwrap"))){
        el.scrollIntoView({
          behavior: "smooth",
          block: "start"
        });
      }
      return true;
    }else{
      el.classList.add("fruti-toc-before")
    }
    return false;
  })
}


const observer = new IntersectionObserver(() => {
  updateActiveLink();
}, {
    rootMargin: "-20% 0px -70% 0px"
  });

document.addEventListener("DOMContentLoaded", () => {
  links = [...document.querySelectorAll(".md-sidebar--secondary a")];
  window.l = links
  headings = [...document.querySelectorAll("h2, h3, h4")];

  headings.forEach((heading) => observer.observe(heading));

  updateActiveLink();
});
