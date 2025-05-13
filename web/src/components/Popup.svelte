<script lang="ts">
  import { accounts, activeAccount, popupDetails, loading, translations } from "../store/stores";
  import { fetchNui } from "../utils/fetchNui";

  let amount: number = 0;
  let comment: string = "";
  let stateid: string = "";
  let account: any;

  $: account = $accounts && Array.isArray($accounts)
    ? $accounts.find((accountItem: any) => $activeAccount === accountItem?.id)
    : null;

  function closePopup() {
    popupDetails.update((val: any) => ({
      ...val,
      actionType: ""
    }));
  }

  function submitInput() {
    loading.set(true);
    fetchNui($popupDetails.actionType, {
      fromAccount: $popupDetails.account.id,
      amount,
      comment,
      stateid
    }).then(retData => {
      setTimeout(() => {
        if (retData !== false) {
          accounts.set(retData);
        }
        loading.set(false);
      }, 1000);
    });
    closePopup();
  }

  let actionInfo: any;
  $: actionInfo = {
    deposit: {
      title: "Deposit Funds",
      icon: "fa-arrow-down-to-line",
      color: "text-fleeca-green",
      buttonColor: "bg-fleeca-green hover:bg-fleeca-dark-green"
    },
    withdraw: {
      title: "Withdraw Funds",
      icon: "fa-arrow-up-from-line",
      color: "text-red-400",
      buttonColor: "bg-fleeca-card border border-fleeca-border hover:bg-fleeca-hover"
    },
    transfer: {
      title: "Transfer Funds",
      icon: "fa-arrow-right-arrow-left",
      color: "text-fleeca-text",
      buttonColor: "bg-fleeca-card border border-fleeca-border hover:bg-fleeca-hover"
    }
  }[$popupDetails.actionType] || { title: "", icon: "", color: "", buttonColor: "" };
</script>

<div class="fixed inset-0 bg-black bg-opacity-70 backdrop-blur-sm flex items-center justify-center z-50 animate-fadeIn">
  <div class="max-w-[500px] w-full bg-fleeca-bg rounded-lg shadow-card overflow-hidden animate-slideUp">
    <div class="bg-fleeca-card p-5 border-b border-fleeca-border">
      <div class="flex justify-between items-center">
        <h2 class="text-xl font-semibold text-fleeca-text font-display">
          {$popupDetails.account.type}{$translations.account || ' Card'} / {$popupDetails.account.id}
        </h2>
        <button 
          class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center text-fleeca-text-secondary hover:text-fleeca-text transition-colors"
          on:click={closePopup}
        >
          <i class="fa-solid fa-xmark"></i>
        </button>
      </div>
      <div class="flex items-center mt-2">
        <div class="w-8 h-8 rounded-full bg-fleeca-bg flex items-center justify-center mr-3">
          <i class={`fas ${actionInfo.icon === 'fa-arrow-down-to-line' ? 'fa-arrow-down' : 
               actionInfo.icon === 'fa-arrow-up-from-line' ? 'fa-arrow-up' : 
               'fa-exchange-alt'} ${actionInfo.color}`}></i>
        </div>
        <span class="text-fleeca-text-secondary">{actionInfo.title}</span>
      </div>
    </div>

    <div class="p-5">
      <form class="space-y-5">
        <div class="space-y-2">
          <label for="amount" class="text-fleeca-text font-medium flex items-center">
            <i class="fa-solid fa-money-bill-wave text-fleeca-green mr-2"></i>
            {$translations.amount || 'Amount'}
          </label>
          <div class="relative">
            <input 
              bind:value={amount} 
              type="number" 
              name="amount" 
              id="amount" 
              placeholder="0.00" 
              class="w-full rounded-lg border border-fleeca-border p-3 pl-10 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all"
            />
            <span class="absolute left-3 top-1/2 transform -translate-y-1/2 text-fleeca-text-secondary">$</span>
          </div>
        </div>

        <div class="space-y-2">
          <label for="comment" class="text-fleeca-text font-medium flex items-center">
            <i class="fa-solid fa-comment text-fleeca-green mr-2"></i>
            {$translations.comment || 'Comment'}
          </label>
          <input 
            bind:value={comment} 
            type="text" 
            name="comment" 
            id="comment" 
            placeholder="Add a note about this transaction" 
            class="w-full rounded-lg border border-fleeca-border p-3 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all"
          />
        </div>

        {#if $popupDetails.actionType === "transfer"}
          <div class="space-y-2">
            <label for="stateId" class="text-fleeca-text font-medium flex items-center">
              <i class="fa-solid fa-user text-fleeca-green mr-2"></i>
              {$translations.transfer || 'Business or Citizen ID'}
            </label>
            <input 
              bind:value={stateid} 
              type="text" 
              name="stateId" 
              id="stateId" 
              placeholder="Enter recipient ID" 
              class="w-full rounded-lg border border-fleeca-border p-3 bg-fleeca-card text-fleeca-text focus:border-fleeca-green transition-all"
            />
          </div>
        {/if}
      </form>
    </div>

    <div class="p-5 bg-fleeca-card border-t border-fleeca-border">
      <div class="flex gap-3">
        <button 
          type="button" 
          class="py-2 px-4 bg-fleeca-card text-fleeca-text rounded-md font-medium hover:bg-fleeca-hover transition-colors flex-1 border border-fleeca-border" 
          on:click={closePopup}
        >
          <i class="fa-solid fa-xmark mr-2"></i>
          {$translations.cancel || 'Cancel'}
        </button>
        <button 
          type="button" 
          class={`py-2 px-4 ${actionInfo.buttonColor} text-white rounded-md font-medium transition-colors flex-1`}
          on:click={submitInput}
        >
          <i class="fa-solid fa-check mr-2"></i>
          {$translations.confirm || 'Submit'}
        </button>
      </div>
    </div>
  </div>
</div>
