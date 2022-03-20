<template>
  <div class="main-wrapper">
    <div class="cpf-field">
      <v-form ref="form" v-on:submit="submitForm">
        <v-text-field label="CPF" v-model="cpf" />
        <v-btn type="submit" @click="initWeb3">Acessar pontuação</v-btn>
      </v-form>
    </div>
    <div class="points-section" v-show="validCpf">
      <div class="points">
        <div>
          {{ points }}
        </div>
        <v-icon small>mdi-star</v-icon>
      </div>
      <div class="subtitle">
        Saldo de estrelas
      </div>
    </div>
    <div class="rewards-section" v-show="validCpf">
      <div class="text">
        Escolha suas recompensas!
      </div>
      <div
      class="reward"
      v-for="reward in rewards"
      :key="reward.title"
      >
        <RewardCard :reward="reward" @clicked="usePoints($event, reward.title)"/>
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import { mapGetters, mapMutations } from 'vuex'
import { loyaltyTransactionABI } from '~/static/loyalty/loyalty_abi.js'
export default {
  name: 'IndexPage',
  data () {
    return {
      cpf: '',
      validCpf: false,
      rewards: [
        {
          title: 'Casquinha de Siri',
          value: '50'
        },
        {
          title: 'Hambúrguer Clássico',
          value: '150'
        },
        {
          title: 'Combo Gigante - 2 em 1',
          value: '250'
        }
      ],
      points: 0
    }
  },
  computed: {
    ...mapGetters('web3', ['getInstance']),
    web3 () {
      return this.getInstance
    }
  },
  methods: {
    usePoints (cost, product) {
      const intCost = parseInt(cost)
      if (intCost > this.points) {
        alert('Você não possui saldo suficiente.')
      } else {
        this.points -= intCost
        const ordersCookieItem = {
          cpf: this.cpf,
          product,
          value: cost
        }
        let ordersCookie = this.$cookies.get('ordersCookie')
        if (ordersCookie === undefined) {
          ordersCookie = []
        }
        ordersCookie.push(ordersCookieItem)
        this.$cookies.set('ordersCookie', ordersCookie)
        this.$store.commit('rescues/setCpf', this.cpf)
        this.$store.commit('rescues/setProduct', product)
        this.$store.commit('rescues/setValue', cost)
        alert('Obrigado por nos escolher novamente! Retire seu pedido no restaurante.')
      }
    },
    submitForm (e) {
      e.preventDefault()
      alert('Now you have access to your data.')
      this.$cookies.set('cpfCookie', this.cpf)
      this.validCpf = true
    },
    ...mapMutations('web3', ['registerWeb3Instance']),
    async initWeb3 () {
      // Check for web3 provider
      if (typeof window.ethereum !== 'undefined') {
        try {
          // Ask to connect
          await window.ethereum.send('eth_requestAccounts')
          const instance = new Web3(window.ethereum)
          // accessing the smart contracts deployed on ethereum Rinkeby testnet
          const myTransactionContract = new instance.eth.Contract(loyaltyTransactionABI, '0x1b9d736BE6Abb6656E22F5F4637dD91790a5e7Eb')
          // Get necessary info on your node
          const points = await myTransactionContract.methods.getPoints(parseInt(this.cpf)).call()
          this.points = points
          /* const networkId = await instance.eth.net.getId()
          const coinbase = await instance.eth.getCoinbase()
          const balance = await instance.eth.getBalance(coinbase)
          // Save it to store
          this.registerWeb3Instance({
            networkId,
            coinbase,
            balance
          }) */
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

<style scoped>
  .main-wrapper {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    row-gap: 48px;
  }
  .points-section {
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    row-gap: 8px;
    margin-top: 32px;
  }
  .points {
    display: flex;
    flex-direction: row;
    justify-content: space-between;
    align-items: center;
    column-gap: 16px;
    font-size: 24px;
  }
  .rewards-section {
    display: flex;
    flex-direction: column;
    width: 100%;
    row-gap: 32px;
  }
  .reward {
    cursor: pointer;
  }
</style>
