<script lang="ts">
  export let transaction: any;
  import { formatMoney } from "../../utils/misc";
  import { translations } from "../../store/stores";
  import { get } from 'svelte/store';

  let translationsValue = get(translations);

  function getTimeElapsed(seconds: number): string {
      let retData: string;
      const timestamp = Math.floor(Date.now() / 1000)-seconds;
      const minutes = Math.floor(timestamp / 60);
      const hours = Math.floor(minutes / 60);
      const days = Math.floor(hours / 24);
      const weeks = Math.floor(days / 7);

   // Make sure translationsValue exists and has the required properties
   if (!translationsValue) {
       translationsValue = {};
   }

   if (weeks !== 0 && weeks > 1) {
       retData = translationsValue.weeks ? translationsValue.weeks.replace("%s", weeks.toString()) : `${weeks} weeks ago`;
   } else if (weeks !== 0 && weeks === 1) {
       retData = translationsValue.aweek || "A week ago";
   } else if (days !== 0 && days > 1) {
       retData = translationsValue.days ? translationsValue.days.replace("%s", days.toString()) : `${days} days ago`;
   } else if (days !== 0 && days === 1) {
       retData = translationsValue.aday || "A day ago";
   } else if (hours !== 0 && hours > 1) {
       retData = translationsValue.hours ? translationsValue.hours.replace("%s", hours.toString()) : `${hours} hours ago`;
   } else if (hours !== 0 && hours === 1) {
       retData = translationsValue.ahour || "An hour ago";
   } else if (minutes !== 0 && minutes > 1) {
       retData = translationsValue.mins ? translationsValue.mins.replace("%s", minutes.toString()) : `${minutes} minutes ago`;
   } else if (minutes !== 0 && minutes === 1) {
       retData = translationsValue.amin || "A minute ago";
   } else {
       retData = translationsValue.secs || "A few seconds ago";
   }
   return retData;
}
  
  // Update the transaction colors for the dark theme
  const isWithdraw = transaction.trans_type === "withdraw";
  const transactionColor = isWithdraw ? "text-red-400" : "text-green-400";
  const transactionBg = isWithdraw ? "bg-red-900/30" : "bg-green-900/30";
  const transactionIcon = isWithdraw ? "fa-arrow-up" : "fa-arrow-down";
  const transactionBorder = isWithdraw ? "border-red-800/50" : "border-green-800/50";
</script>

<div class="bg-fleeca-card rounded-lg overflow-hidden group animate-slideUp border border-fleeca-border hover:shadow-card transition-all">
  <div class="p-4">
      <!-- Transaction header -->
      <div class="flex justify-between items-center mb-3">
          <div class="flex items-center gap-2">
              <div class={`w-8 h-8 rounded-full ${transactionBg} flex items-center justify-center border ${transactionBorder}`}>
                  <i class={`fas ${transactionIcon} ${transactionColor}`}></i>
              </div>
              <div>
                  <span class="font-medium text-fleeca-text">{transaction.title}</span>
                  <span class="ml-2 text-xs px-2 py-0.5 bg-fleeca-bg rounded-full" class:text-red-400={isWithdraw} class:text-green-400={!isWithdraw}>
                      {transaction.trans_type}
                  </span>
              </div>
          </div>
          <span class="text-xs text-fleeca-text-secondary bg-fleeca-bg px-2 py-1 rounded-full">
              {transaction.trans_id.substring(0, 8)}
          </span>
      </div>
      
      <!-- Transaction amount and details -->
      <div class="flex justify-between items-center mb-3">
          <div>
              <span class={`${transactionColor} text-lg font-semibold`}>
                  {formatMoney(transaction.amount)}
              </span>
              <div class="text-fleeca-text-secondary text-xs mt-1">{transaction.receiver}</div>
          </div>
          
          <div class="text-right">
              <div class="text-fleeca-text text-sm">{getTimeElapsed(transaction.time)}</div>
              <div class="text-fleeca-text-secondary text-xs">{transaction.issuer}</div>
          </div>
      </div>
      
      <!-- Transaction message -->
      <div class="bg-fleeca-bg p-3 rounded-lg mt-2 group-hover:bg-fleeca-hover transition-colors duration-300 border border-fleeca-border">
          <div class="text-fleeca-text-secondary text-xs mb-1">{translationsValue.message || 'Message'}</div>
          <div class="text-fleeca-text text-sm">{transaction.message}</div>
      </div>
  </div>
</div>
