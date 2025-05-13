<script lang="ts">
 import { createEventDispatcher } from 'svelte';
 import { translations } from '../../store/stores';
 
 const categories = [
   { id: 'all', label: 'All Accounts', icon: 'fa-credit-card' },
   { id: 'personal', label: 'Personal', icon: 'fa-user' },
   { id: 'business', label: 'Business', icon: 'fa-briefcase' },
   { id: 'org', label: 'Organization', icon: 'fa-building' }
 ];
 
 export let selectedCategory = 'all';
 
 const dispatch = createEventDispatcher();
 
 function selectCategory(categoryId: string) {
   selectedCategory = categoryId;
   dispatch('categoryChange', categoryId);
 }
</script>

<div class="category-selector mb-4">
 <h4 class="text-sm font-medium text-fleeca-text-secondary mb-2">
   {$translations.filter_accounts || 'Filter Accounts'}
 </h4>
 
 <div class="flex flex-wrap gap-2">
   {#each categories as category}
     <button 
       class="category-btn {selectedCategory === category.id ? 'active' : ''}"
       on:click={() => selectCategory(category.id)}
       aria-label={category.label}
     >
       <i class="fas {category.icon} mr-2"></i>
       <span>{category.label}</span>
     </button>
   {/each}
 </div>
</div>

<style>
 .category-selector {
   width: 100%;
 }
 
 .category-btn {
   display: flex;
   align-items: center;
   padding: 0.5rem 0.75rem;
   background-color: var(--fleeca-card);
   border: 1px solid var(--fleeca-border);
   border-radius: var(--border-radius);
   color: var(--fleeca-text-secondary);
   font-size: 0.875rem;
   transition: all var(--transition-normal);
 }
 
 .category-btn:hover {
   background-color: var(--fleeca-hover);
   color: var(--fleeca-text);
 }
 
 .category-btn.active {
   background-color: var(--fleeca-green);
   border-color: var(--fleeca-dark-green);
   color: white;
 }
</style>
