interface DebugEvent<T = any> {
  action: string
  data: T
}

// Update the isEnvBrowser function to be more robust

export const isEnvBrowser = (): boolean => {
  try {
    return !(window as any).invokeNative
  } catch (e) {
    return true
  }
}

/**
 * Emulates dispatching an event using SendNuiMessage in the lua scripts.
 * This is used when developing in browser
 *
 * @param events - The event you want to cover
 * @param timer - How long until it should trigger (ms)
 */
export const debugData = <T>(events: DebugEvent<T>[], timer: number = 1000): void => {
  if (isEnvBrowser()) {
    for (const event of events) {
      setTimeout(() => {
        window.dispatchEvent(
          new MessageEvent('message', {
            data: {
              action: event.action,
              data: event.data,
            },
          }),
        );
      }, timer);
    }
  }
};
