export interface INavigationRoute {
  name: string
  displayName: string
  meta: { icon: string }
  children?: INavigationRoute[]
}

export default {
  root: {
    name: '/',
    displayName: 'navigationRoutes.home',
  },
  routes: [
    {
      name: 'dashboard',
      displayName: 'menu.dashboard',
      meta: {
        icon: 'material-icons-dashboard',
      },
    },
    {
      name: 'newscan',
      displayName: 'menu.newscan',
      meta: {
        icon: 'material-icons-wifi_tethering',
      },
    },
    {
      name: 'importscan',
      displayName: 'menu.importscan',
      meta: {
        icon: 'material-icons-upload_file',
      },
    },
    {
      name: 'editTemplate',
      displayName: 'menu.edittemplate',
      meta: {
        icon: 'material-icons-edit',
      },
    },
    {
      name: 'settings',
      displayName: 'menu.settings',
      meta: {
        icon: 'material-icons-gear',
      },
    },
  ] as INavigationRoute[],
}
