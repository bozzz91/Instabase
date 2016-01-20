<div class="nav category-nav" role="navigation">
    <ul>
        <li class="category-tab">
            <a class="a-category-tab tab-geo ${category == 'Геолокация' ? 'active' : 'not-active'}" href="${createLink(action: free ? 'free' : 'index', params: ['category':'Геолокация'])}">Геолокация</a>
        </li>
        <li class="category-tab">
            <a class="a-category-tab tab-vk ${category == 'VK' ? 'active' : 'not-active'}" href="${createLink(action: free ? 'free' : 'index', params: ['category':'VK'])}">VK</a>
        </li>
        <li class="category-tab">
            <a class="a-category-tab tab-insta ${category == 'Instagram' ? 'active' : 'not-active'}" href="${createLink(action: free ? 'free' : 'index', params: ['category':'Instagram'])}">Instagram</a>
        </li>
        <li class="category-tab">
            <a class="a-category-tab tab-filter ${category == 'Фильтры' ? 'active' : 'not-active'}" href="${createLink(action: free ? 'free' : 'index', params: ['category':'Фильтры'])}">Фильтры</a>
        </li>
    </ul>
</div>