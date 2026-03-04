const toggle = document.querySelector('.toggle'),
    sidebar = document.querySelector('.category-sidebar');
    
toggle.addEventListener('click', () => {
    toggle.classList.toggle('fa-chevron-right')
    sidebar.classList.toggle('close')
})
//<i class="fa-solid fa-chevron-left"></i>
