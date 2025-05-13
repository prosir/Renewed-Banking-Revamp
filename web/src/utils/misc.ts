import { currency } from "../store/stores"

export const isEnvBrowser = (): boolean => !(window as any).invokeNative

let activeCurrency = "USD" // Default value

currency.subscribe((value: string) => {
  activeCurrency = value || "USD" // Ensure we always have a value
})

export function formatMoney(number: number) {
  if (typeof number !== "number") {
    number = 0 // Default to 0 if not a number
  }
  return number.toLocaleString("en-US", { style: "currency", currency: activeCurrency })
}
