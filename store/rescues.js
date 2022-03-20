export const state = () => ({
  cpf: '',
  product: '',
  value: ''
})

export const mutations = {
  setCpf (state, cpf) {
    state.cpf = cpf
  },
  setProduct (state, product) {
    state.product = product
  },
  setValue (state, value) {
    state.value = value
  }
}
