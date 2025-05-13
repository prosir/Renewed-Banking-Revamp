<script lang="ts">
  import { fetchNui } from '../utils/fetchNui';
  import { onMount } from 'svelte';
  import { 
    visibility,
    accounts,
    activeAccount,
    loading,
    notify,
    popupDetails,
    atm,
    translations,
    currency
  } from '../store/stores';
  import { useNuiEvent } from '../utils/useNuiEvent';

  let isVisible: boolean = false;

  visibility.subscribe(visible => {
    isVisible = visible;
  });

  useNuiEvent<any>('setVisible', data => {
    visibility.set(false);
    accounts.set([]);
    activeAccount.set(null);
    loading.set(false);
    atm.set(false);

    if (!data) return;

    visibility.set(data.status === true);
    loading.set(data.loading === true);
    atm.set(data.atm === true);

    if (data.platinumThreshold) {
      localStorage.setItem('platinumThreshold', data.platinumThreshold.toString());
    }

    if (data.accounts && Array.isArray(data.accounts)) {
      accounts.set(data.accounts);
      if (data.accounts.length > 0 && data.accounts[0] && data.accounts[0].id) {
        activeAccount.set(data.accounts[0].id);
      }
    }
  });

  useNuiEvent<any>('setLoading', data => {
    loading.set(data.status);
  });

  useNuiEvent<any>('notify', data => {
    notify.set(data.status);
    setTimeout(() => {
      notify.set("");
    }, 3500);
  });

  useNuiEvent<any>('updateLocale', data => {
    translations.set(data.translations);
    currency.set(data.currency);
  });

  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (isVisible && ['Escape'].includes(e.code)) {
        fetchNui('closeInterface');
        visibility.set(false);
        popupDetails.update((val) => ({
          ...val,
          actionType: "",
        }));
      }
    };

    window.addEventListener('keydown', keyHandler);
    return () => window.removeEventListener('keydown', keyHandler);
  });
</script>

{#if $visibility}
  <slot />
{/if}
