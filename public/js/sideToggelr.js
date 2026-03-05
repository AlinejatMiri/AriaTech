const toggle = document.querySelector('.toggle'),
    sidebar = document.querySelector('.category-sidebar'),
    menuToggle = document.getElementById('menuToggle'),
    mainLayout = document.querySelector('.main-layout');

function updateLayout() {
    if (mainLayout) {
        if (sidebar.classList.contains('close')) {
            mainLayout.classList.add('sidebar-closed');
        } else {
            mainLayout.classList.remove('sidebar-closed');
        }
    }
}

function closeSidebar() {
    sidebar.classList.add('close');
    updateLayout();
}

function openSidebar() {
    sidebar.classList.remove('close');
    updateLayout();
}

toggle.addEventListener('click', () => {
    sidebar.classList.toggle('close');
    updateLayout();
});

if (menuToggle) {
    menuToggle.addEventListener('click', () => {
        sidebar.classList.toggle('close');
        updateLayout();
    });
}

updateLayout();
