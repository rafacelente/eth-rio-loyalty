<template>
  <v-app dark>
    <v-navigation-drawer
      v-model="drawer"
      :mini-variant="miniVariant"
      :clipped="clipped"
      fixed
      app
    >
      <v-list>
        <v-list-item
          v-for="(item, i) in items"
          :key="i"
          :to="item.to"
          router
          exact
        >
          <v-list-item-action>
            <v-icon>{{ item.icon }}</v-icon>
          </v-list-item-action>
          <v-list-item-content>
            <v-list-item-title v-text="item.title" />
          </v-list-item-content>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-app-bar
      :clipped-left="clipped"
      fixed
      app
    >
      <v-app-bar-nav-icon @click.stop="drawer = !drawer" />
      <v-btn
        icon
        @click.stop="miniVariant = !miniVariant"
      >
        <v-icon>mdi-{{ `chevron-${miniVariant ? 'right' : 'left'}` }}</v-icon>
      </v-btn>
      <v-btn
        icon
        @click.stop="clipped = !clipped"
      >
        <v-icon>mdi-application</v-icon>
      </v-btn>
      <v-btn
        icon
        @click.stop="fixed = !fixed"
      >
        <v-icon>mdi-minus</v-icon>
      </v-btn>
      <v-toolbar-title v-text="title" />
      <v-spacer />
      <v-btn
        icon
        @click.stop="rightDrawer = !rightDrawer"
      >
        <v-icon>mdi-menu</v-icon>
      </v-btn>
    </v-app-bar>
    <v-main>
      <!-- <div class="p-4">
        <MetaMask @connect="initWeb3" />
        <div>
          <p>Network: {{ web3.networkId }}</p>
          <p>Account: {{ web3.coinbase }}</p>
          <p>Balance: {{ web3.balance }}</p>
        </div>
        <p class="italic text-red-600">{{ errorMessage }}</p>
      </div> -->
      <v-container>
        <Nuxt />
      </v-container>
    </v-main>
    <v-navigation-drawer
      v-model="rightDrawer"
      :right="right"
      temporary
      fixed
    >
      <v-list>
        <v-list-item @click.native="right = !right">
          <v-list-item-action>
            <v-icon light>
              mdi-repeat
            </v-icon>
          </v-list-item-action>
          <v-list-item-title>Switch drawer (click me)</v-list-item-title>
        </v-list-item>
      </v-list>
    </v-navigation-drawer>
    <v-footer
      :absolute="!fixed"
      app
    >
      <span>&copy; {{ new Date().getFullYear() }}</span>
    </v-footer>
  </v-app>
</template>

<script>
import Web3 from 'web3'
import { mapGetters, mapMutations } from 'vuex'
export default {
  name: 'DefaultLayout',
  data () {
    return {
      errorMessage: '',
      clipped: false,
      drawer: false,
      fixed: false,
      items: [
        {
          icon: 'mdi-apps',
          title: 'Home Client',
          to: '/'
        },
        {
          icon: 'mdi-chart-bubble',
          title: 'Home Owner',
          to: '/ownerPage'
        }
      ],
      miniVariant: false,
      right: true,
      rightDrawer: false,
      title: 'Home'
    }
  },
  computed: {
    ...mapGetters('web3', ['getInstance']),
    web3 () {
      return this.getInstance
    }
  },
  methods: {
    ...mapMutations('web3', ['registerWeb3Instance']),
    async initWeb3 () {
      // Check for web3 provider
      if (typeof window.ethereum !== 'undefined') {
        try {
          // Ask to connect
          await window.ethereum.send('eth_requestAccounts')
          const instance = new Web3(window.ethereum)
          // Get necessary info on your node
          const networkId = await instance.eth.net.getId()
          const coinbase = await instance.eth.getCoinbase()
          const balance = await instance.eth.getBalance(coinbase)
          // Save it to store
          this.registerWeb3Instance({
            networkId,
            coinbase,
            balance
          })
        } catch (error) {
          // User denied account access
          console.error('User denied web3 access', error)
        }
      } else {
        console.error('No web3 provider detected')
      }
    }
  }
}
</script>
