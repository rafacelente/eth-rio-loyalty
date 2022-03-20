<template>
  <div class="form-wrapper">
    <div class="title">
      Coloque os dados para gerar o prêmio para cliente
    </div>
    <v-form class="forms" ref="form" v-on:submit="submitForm">
      <v-text-field
       v-for="q in questions"
       :key="q.title"
       :label="q.title"
       v-model="q.value"
       :rules="rules"/>
      <v-btn block color="#403999" type="submit" @click="initWeb3">Confirmar</v-btn>
    </v-form>
    <div class="orders-section">
      <div class="title">
        Operações de resgate realizadas
      </div>
      <div
      class="order"
      v-for="order in orders"
      :key="order.cpf"
      >
        {{order.cpf + ' ordered ' + order.product + ' that costed ' + order.value + ' stars.'}}
      </div>
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import { loyaltyTransactionABI } from '~/static/loyalty/loyalty_abi.js'
export default {
  name: 'InspirePage',
  data () {
    return {
      questions: [
        {
          title: 'Identity number',
          value: ''
        },
        {
          title: 'Total spendings',
          value: ''
        }
      ],
      rules: [
        v => !!v || 'Required field.',
        v => /^[0-9].*?/.test(v) || 'Type a number!'
      ],
      cpfs: [],
      products: [],
      values: []
    }
  },
  computed: {
    orders () {
      return this.$cookies.get('ordersCookie')
    }
  },
  methods: {
    submitForm (e) {
      e.preventDefault()
      // do something with values
      let validated = true
      for (let i = 0; i < this.questions.length; i++) {
        if (this.questions[i].value === '' || /^[0-9].*?/.test(this.questions[i].value) === false) {
          validated = false
        }
      }
      if (validated) {
        alert('Successful submission.')
      } else {
        alert('Preencha o formulário corretamente.')
      }
      setTimeout(() => {
        this.$refs.form.reset()
      }, 2000)
    },
    async initWeb3 () {
      if (typeof window.ethereum !== 'undefined') {
        try {
          const accounts = await window.ethereum.send('eth_requestAccounts')
          const instance = new Web3(window.ethereum)
          const userAccount = accounts.result[0]
          const myTransactionContract = new instance.eth.Contract(loyaltyTransactionABI, '0x1b9d736BE6Abb6656E22F5F4637dD91790a5e7Eb')
          await myTransactionContract.methods.sumPoints(parseInt(this.questions[1].value), parseInt(this.questions[0].value)).send({ from: userAccount })
        } catch (error) {
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
  .form-wrapper {
    display: flex;
    flex-direction: column;
    width: 100%;
    margin-top: 32px;
  }
  .orders-section {
    margin-top: 32px;
    display: flex;
    flex-direction: column;
    row-gap: 8px;
  }
</style>
