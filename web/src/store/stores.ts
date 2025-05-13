import { writable } from "svelte/store"

export const visibility = writable(false)
export const loading = writable(false)
export const notify = writable<
  | string
  | {
      message: string
      title?: string
      type?: "success" | "error" | "info"
    }
>("")
export const activeAccount = writable(null)
export const atm = writable(false)
export const currency = writable("USD")

export const popupDetails = writable({
  account: {},
  actionType: "",
})


export const accounts = writable<any[]>([])


export const translations = writable<any>({})
