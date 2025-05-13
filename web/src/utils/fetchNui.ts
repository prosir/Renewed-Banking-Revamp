/**
 * @param eventName - The endpoint eventname to target
 * @param data - Data you wish to send in the NUI Callback
 * @return returnData - A promise for the data sent back by the NuiCallbacks CB argument
 */
const identity: string = atob("UmVuZXdlZC1CYW5raW5n")
export async function fetchNui<T = any>(eventName: string, data: unknown = {}, awaitResponse = false): Promise<T> {
  try {
    const options = {
      method: "post",
      headers: {
        "Content-Type": "application/json; charset=UTF-8",
      },
      body: JSON.stringify(data),
    }

    const resp = await fetch(`https://${identity}/${eventName}`, options)


    const text = await resp.text()
    if (!text) {
      console.log(`Empty response from ${eventName}`)
      return {} as T
    }


    if (!awaitResponse) {
      try {
        return JSON.parse(text)
      } catch (e) {
        console.error(`Failed to parse JSON from ${eventName}:`, text)
        return {} as T
      }
    }


    return new Promise((resolve) => {
      const timeout = setTimeout(() => {
        window.removeEventListener("message", handler)
        console.error(`Timeout waiting for response from ${eventName}`)
        resolve({} as T)
      }, 5000)

      const handler = (event: MessageEvent) => {
        if (event.data.action === "accountsData" || event.data.action === "setVisible") {
          clearTimeout(timeout)
          window.removeEventListener("message", handler)
          resolve(event.data.data as T)
        }
      }

      window.addEventListener("message", handler)
    })
  } catch (error) {
    console.error(`Error in fetchNui (${eventName}):`, error)
    return {} as T
  }
}
