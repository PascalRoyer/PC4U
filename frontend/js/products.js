    document.getElementById('year').textContent = new Date().getFullYear();

    const datasetFiles = [
        "cpu.json"
    //   "case.json",
    //   "case-accessory.json",
    //   "case-fan.json",
    //   "cpu-cooler.json",
    //   "memory.json",
    //   "motherboard.json",
    //   "monitor.json",
    //   "mouse.json",
    //   "keyboard.json",
    //   "video-card.json",
    //   "power-supply.json",
    //   "os.json",
    //   "external-hard-drive.json",
    //   "internal-hard-drive.json",
    //   "sound-card.json",
    //   "speakers.json",
    //   "headphones.json",
    //   "thermal-paste.json",
    //   "ups.json",
    //   "fan-controller.json",
    //   "optical-drive.json",
    //   "webcam.json",
    //   "wired-network-card.json",
    //   "wireless-network-card.json"
    //la base de donnés des produits sera ajoutée plus tard car il est lent à charger plusieurs fichiers
    ];

    const productGrid = document.getElementById('productGrid');
    let allProducts = [];

    async function loadProducts() {
      for (const file of datasetFiles) {
        try {
          const res = await fetch(`./dataset/${file}`);
          if (!res.ok) continue;
          const data = await res.json();
          // Chaque fichier JSON peut contenir un tableau de produits
          allProducts = allProducts.concat(data);
        } catch (err) {
          console.error("Erreur fichier", file, err);
        }
      }
      displayProducts(allProducts);
    }

    function displayProducts(list) {
      productGrid.innerHTML = '';
      list.forEach(prod => {
        const card = document.createElement('div');
        card.className = 'product-card';
        card.innerHTML = `
          <img src="${prod.image || './assets/img/default.png'}" alt="${prod.name}" />
          <h3>${prod.name || prod.title || "Produit"}</h3>
          <p>${prod.category || prod.type || ""}</p>
          <div class="price">${prod.price ? prod.price + " $" : "—"}</div>
          <button class="btn btn-primary">Ajouter</button>
        `;
        productGrid.appendChild(card);
      });
    }

    // Recherche
    const searchInput = document.getElementById('searchInput');
    searchInput.addEventListener('input', () => {
      const query = searchInput.value.toLowerCase();
      const filtered = allProducts.filter(p =>
        (p.name && p.name.toLowerCase().includes(query)) ||
        (p.category && p.category.toLowerCase().includes(query))
      );
      displayProducts(filtered);
    });

    loadProducts();
