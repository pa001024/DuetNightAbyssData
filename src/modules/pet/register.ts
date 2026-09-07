import type { ModulePlugin } from "../../core/plugin.ts"
import { petEntryModule } from "./petEntryModule.ts"
import { petModule } from "./petModule.ts"

export const plugins: ModulePlugin[] = [
    { name: "PetEntry", build: ctx => ({ PetEntry: petEntryModule(ctx) }) },
    { name: "Pet", deps: ["Skill"], build: ctx => ({ Pet: petModule(ctx) }) },
]
